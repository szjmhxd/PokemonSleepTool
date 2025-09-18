import tkinter as tk
from tkinter import ttk, messagebox
import pymysql

class RecipeApp:
    def __init__(self):
        # 初始化主窗口
        self.root = tk.Tk()
        self.root.title('宝可梦睡眠食谱查询 v2.0')
        self.root.geometry('1200x800')
        self.root.minsize(1000, 600)

        # 主容器
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # 数据库连接
        try:
            self.conn = pymysql.connect(
                host='localhost',
                port=3306,
                user='root',
                password='root',
                database='pokemonsleep',
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
        except pymysql.Error as e:
            messagebox.showerror("数据库错误", f"连接失败: {str(e)}")
            self.root.destroy()
            return

            # 创建食谱标签页
        recipe_frame = ttk.Frame(notebook)
        notebook.add(recipe_frame, text='食谱查询')

        # 搜索面板
        self.search_frame = ttk.Frame(recipe_frame)
        self.search_frame.pack(fill=tk.X, pady=(0,10))
            
        self.search_entry = ttk.Entry(self.search_frame)
        self.category_combo = ttk.Combobox(self.search_frame, state='readonly', width=18)
        self.search_button = ttk.Button(self.search_frame, text='搜索食谱', command=self.search_recipes)
        
        # 布局搜索组件
        self.search_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
        self.category_combo.pack(side=tk.LEFT, padx=2)
        self.search_button.pack(side=tk.LEFT, padx=2)

        #检查组件
        self.check_button = ttk.Button(self.search_frame, text="检查食材充足", command=self.check_ingredients)
        self.check_button.pack(side=tk.LEFT, padx=5)

        # 主内容区分栏
        content_paned = ttk.PanedWindow(recipe_frame, orient=tk.HORIZONTAL)
        content_paned.pack(fill=tk.BOTH, expand=True)

        # 左侧食谱列表
        left_frame = ttk.Frame(content_paned)
        self.tree = ttk.Treeview(left_frame, columns=('ID','名称','分类','卡路里','状态'), 
                               show='headings', height=20)
        
        self.tree.tag_configure('sufficient', foreground='green') 

        # 添加滚动条
        tree_scroll = ttk.Scrollbar(left_frame, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscrollcommand=tree_scroll.set)
        
        # 布局左侧组件
        self.tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        tree_scroll.pack(side=tk.RIGHT, fill=tk.Y)

        # 右侧食材详情
        right_frame = ttk.Frame(content_paned)
        self.ingredient_tree = ttk.Treeview(right_frame, columns=('食材名称', '所需数量', '库存'),
                                          show='headings', height=15)
        
        # 布局右侧组件
        self.ingredient_tree.pack(fill=tk.BOTH, expand=True, padx=5)
        
        # 创建食材管理标签页
        ingredient_frame = ttk.Frame(notebook)
        notebook.add(ingredient_frame, text='食材管理')

        # 食材表格
        self.ingredient_tree = ttk.Treeview(ingredient_frame, columns=('name', 'quantity'), show='headings')
        self.ingredient_tree.heading('name', text='食材名称', command=lambda: self.sort_ingredients('name'))
        self.ingredient_tree.heading('quantity', text='库存数量', command=lambda: self.sort_ingredients('quantity'))
        self.ingredient_tree.column('name', width=200)
        self.ingredient_tree.column('quantity', width=100)

        # 添加滚动条
        scrollbar = ttk.Scrollbar(ingredient_frame, orient=tk.VERTICAL, command=self.ingredient_tree.yview)
        self.ingredient_tree.configure(yscrollcommand=scrollbar.set)
        
        # 布局
        self.ingredient_tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        # 绑定双击编辑事件
        self.ingredient_tree.bind('<Double-1>', self.edit_ingredient_quantity)

        # 加载初始数据
        self.load_ingredients()

        # 添加分栏
        content_paned.add(left_frame, weight=3)
        content_paned.add(right_frame, weight=1)

        # 配置表格列
        self._configure_columns()
        
        # 初始化分类数据
        self.load_categories()
        
        # 绑定事件
        self.tree.bind('<<TreeviewSelect>>', self.show_ingredients)
        self.tree.bind("<Button-3>", self.show_context_menu)

        # 默认加载数据
        self.search_recipes()
        
        self.root.mainloop()

    def _configure_columns(self):
        # 配置食谱列表列
        columns = {
            'ID': {'width': 60, 'anchor': 'center'},
            '名称': {'width': 200},
            '分类': {'width': 120},
            '卡路里': {'width': 80, 'anchor': 'center'},
            '状态': {'width': 100, 'anchor': 'center'}
        }
        
        for col, config in columns.items():
            self.tree.heading(col, text=col)
            self.tree.column(col, **config)
        
        # 配置食材详情列
        ingredient_columns = {
            '食材名称': {'width': 150},
            '所需数量': {'width': 80, 'anchor': 'center'},
            '库存': {'width': 80, 'anchor': 'center'}
        }
        
        for col, config in ingredient_columns.items():
            self.ingredient_tree.heading(col, text=col)
            self.ingredient_tree.column(col, **config)
        
        # 配置标签样式
        self.tree.tag_configure('unmade', background='#ffeeee')
        self.ingredient_tree.tag_configure('lack', background='#ffdddd')

    def load_categories(self):
        query = """
            SELECT d1.id, d1.type_name 
            FROM dict d1
            WHERE d1.parent_id = 1
            ORDER BY d1.sort_order
        """
        with self.conn.cursor() as cursor:
            cursor.execute(query)
            # 修改后
            categories = [('全部(0)', 0)] + [(row['type_name'] + '(' + str(row['id']) + ')', row['id']) for row in cursor.fetchall()]

            
            self.category_combo['values'] = [name for name, id in categories]
            self.category_combo.set('全部')
            
            # 存储映射关系
            self.category_map = {name: id for name, id in categories}

    def search_recipes(self):
        # 获取分类ID
        selected = self.category_combo.get()
        category_id = selected.split('(')[-1].strip(')') if selected else '0'
        
        base_query = """
            SELECT r.id, r.name, d.type_name, r.calories, r.is_made
            FROM recipes r
            JOIN dict d ON r.category_id = d.id
            WHERE d.parent_id = 1
        """
        params = []
        
        # 分类筛选
        if category_id != '0':
            base_query += " AND d.id = %s"
            params.append(category_id)
        
        # 关键字筛选
        keyword = self.search_entry.get().strip()
        if keyword:
            base_query += " AND r.name LIKE %s"
            params.append(f'%{keyword}%')
        
        # 排序
        base_query += " ORDER BY r.sort DESC"
        
        with self.conn.cursor() as cursor:
            cursor.execute(base_query, params)
            results = cursor.fetchall()
            
            self.tree.delete(*self.tree.get_children())

            for row in results:
                status = '已做' if row['is_made'] == 1 else '未做'
                tags = ('unmade',) if row['is_made'] == 2 else ()
                self.tree.insert('', 'end', 
                    values=(row['id'], row['name'], row['type_name'], row['calories'], status),
                    tags=tags
                )    

    def show_ingredients(self, event):
        item = self.tree.selection()[0]
        
        selected_values = self.tree.item(item, 'values')
        recipe_id = selected_values[0] if selected_values else None

        query = """
            SELECT i.name, ri.quantity_required, i.quantity
            FROM recipe_ingredients ri
            JOIN ingredients i ON ri.ingredient_id = i.id
            WHERE ri.recipe_id = %s
        """
        with self.conn.cursor() as cursor:
            cursor.execute(query, (recipe_id,))
            ingredients = cursor.fetchall()
            
            # 清空旧数据
            self.ingredient_tree.delete(*self.ingredient_tree.get_children())
            
            # 插入新数据
        for ingredient in ingredients:
            self.ingredient_tree.insert('', 'end', 
                values=(
                    ingredient['name'], 
                    ingredient['quantity_required'],
                    ingredient['quantity']
                ),
                tags=('lack',) if ingredient['quantity'] < ingredient['quantity_required'] else ()
            )

    def check_ingredients(self):
        # 遍历所有食谱
        for item in self.tree.get_children():
            recipe_id = self.tree.item(item, 'values')[0]
            # 获取食谱所需食材
            with self.conn.cursor() as cursor:
                cursor.execute("""
                    SELECT 
                        i.name,
                        ri.quantity_required AS required_quantity,
                        i.quantity AS available_quantity,
                        CASE 
                            WHEN ri.quantity_required <= i.quantity THEN '充足'
                            ELSE '不足'
                        END AS status
                    FROM recipe_ingredients ri
                    JOIN ingredients i ON ri.ingredient_id = i.id
                    WHERE ri.recipe_id = %s
                """, (recipe_id,))

            # 调整后的判断逻辑
            ingredients = cursor.fetchall()
            all_sufficient = all(
                row['available_quantity'] >= row['required_quantity']
                for row in ingredients
            )

            # 修改后（保留原有标签）
            current_tags = list(self.tree.item(item, 'tags'))
            if all_sufficient:
                if 'sufficient' not in current_tags:
                    current_tags.append('sufficient')
            else:
                current_tags = [t for t in current_tags if t != 'sufficient']
            self.tree.item(item, tags=tuple(current_tags))    

    # 新增上下文菜单方法
    def show_context_menu(self, event):
        item = self.tree.identify_row(event.y)
        if item and self.tree.identify_column(event.x) == '#5':  # 判断是否点击状态列
            menu = tk.Menu(self.root, tearoff=0)
            current_status = self.tree.item(item, 'values')[4]
            
            if current_status == '已做':
                menu.add_command(label="标记为未做", command=lambda: self.update_recipe_status(item, 2))
            else:
                menu.add_command(label="标记为已做", command=lambda: self.update_recipe_status(item, 1))
                
            menu.post(event.x_root, event.y_root)

    # 新增状态更新方法
    def update_recipe_status(self, item, new_status):
        recipe_id = self.tree.item(item, 'values')[0]
        try:
            with self.conn.cursor() as cursor:
                cursor.execute("UPDATE recipes SET is_made = %s WHERE id = %s", (new_status, recipe_id))
                self.conn.commit()
            self.search_recipes()  # 刷新列表
        except Exception as e:
            messagebox.showerror("更新错误", f"状态更新失败: {str(e)}")


    def load_ingredients(self):
        try:
            with self.conn.cursor() as cursor:
                cursor.execute("SELECT name, quantity FROM ingredients ORDER BY sort ASC")
                for row in self.ingredient_tree.get_children():
                    self.ingredient_tree.delete(row)
                for item in cursor.fetchall():
                    self.ingredient_tree.insert('', 'end', values=(item['name'], item['quantity']))
        except pymysql.Error as e:
            messagebox.showerror("数据库错误", f"加载食材失败: {str(e)}")

    def edit_ingredient_quantity(self, event):
        item = self.ingredient_tree.selection()[0]
        current_values = self.ingredient_tree.item(item, 'values')
        
        new_quantity = simpledialog.askfloat("修改数量", "请输入新数量:", 
                                            initialvalue=current_values[1],
                                            minvalue=0, maxvalue=1000)
        
        if new_quantity is not None:
            try:
                with self.conn.cursor() as cursor:
                    cursor.execute("""
                        UPDATE ingredients 
                        SET quantity = %s
                        WHERE name = %s
                    """, (new_quantity, current_values[0]))
                self.conn.commit()
                self.load_ingredients()  # 刷新数据
            except pymysql.Error as e:
                messagebox.showerror("更新失败", f"错误: {str(e)}")
                self.conn.rollback()   

if __name__ == '__main__':
    app = RecipeApp()
