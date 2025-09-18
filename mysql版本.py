import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import pymysql


class RecipeApp:
    def __init__(self):
        # 初始化主窗口
        self.root = tk.Tk()
        self.root.title("宝可梦睡眠食谱查询 v2.0")
        self.root.geometry("1200x800")
        self.root.minsize(1000, 600)

        # 当窗口关闭时调用 on_closing 方法，确保关闭数据库连接
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

        # 创建选项卡容器
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # 初始化数据库连接
        try:
            self.conn = pymysql.connect(
                host="**.mysql.com*",
                port=3306,
                user="root",
                password="root",
                database="pokemonsleep",
                charset="utf8mb4",
                cursorclass=pymysql.cursors.DictCursor,
            )
            print("数据库连接成功")
        except pymysql.Error as e:
            messagebox.showerror("数据库错误", f"连接失败: {str(e)}")
            self.root.destroy()
            return

        # ========== 食谱标签页 ==========
        recipe_frame = ttk.Frame(notebook)
        notebook.add(recipe_frame, text="食谱查询")

        # 搜索框和按钮区域
        self.search_frame = ttk.Frame(recipe_frame)
        self.search_frame.pack(fill=tk.X, pady=(0, 10))

        self.search_entry = ttk.Entry(self.search_frame)
        self.search_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)

        self.category_combo = ttk.Combobox(
            self.search_frame, state="readonly", width=18
        )
        self.category_combo.pack(side=tk.LEFT, padx=2)

        self.search_button = ttk.Button(
            self.search_frame, text="搜索食谱", command=self.search_recipes
        )
        self.search_button.pack(side=tk.LEFT, padx=2)

        self.check_button = ttk.Button(
            self.search_frame, text="检查食材充足", command=self.check_ingredients
        )
        self.check_button.pack(side=tk.LEFT, padx=5)

        # 主内容区域：左右分栏
        content_paned = ttk.PanedWindow(recipe_frame, orient=tk.HORIZONTAL)
        content_paned.pack(fill=tk.BOTH, expand=True)

        # 左侧食谱列表
        left_frame = ttk.Frame(content_paned)
        self.recipe_tree = ttk.Treeview(
            left_frame,
            columns=("ID", "名称", "分类", "卡路里", "状态"),
            show="headings",
            height=20,
        )
        # 配置滚动条
        tree_scroll = ttk.Scrollbar(
            left_frame, orient=tk.VERTICAL, command=self.recipe_tree.yview
        )
        self.recipe_tree.configure(yscrollcommand=tree_scroll.set)

        self.recipe_tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        tree_scroll.pack(side=tk.RIGHT, fill=tk.Y)

        # 右侧食材详情
        right_frame = ttk.Frame(content_paned)
        self.recipe_ingredient_tree = ttk.Treeview(
            right_frame,
            columns=("食材名称", "所需数量", "库存"),
            show="headings",
            height=15,
        )
        self.recipe_ingredient_tree.pack(fill=tk.BOTH, expand=True, padx=5)

        # 加入分栏
        content_paned.add(left_frame, weight=3)
        content_paned.add(right_frame, weight=1)

        # ========== 食材管理标签页 ==========
        ingredient_frame = ttk.Frame(notebook)
        notebook.add(ingredient_frame, text="食材管理")

        self.ingredient_manage_tree = ttk.Treeview(
            ingredient_frame, columns=("name", "quantity"), show="headings"
        )
        self.ingredient_manage_tree.heading(
            "name", text="食材名称", command=lambda: self.sort_ingredients("name")
        )
        self.ingredient_manage_tree.heading(
            "quantity",
            text="库存数量",
            command=lambda: self.sort_ingredients("quantity"),
        )
        self.ingredient_manage_tree.column("name", width=200)
        self.ingredient_manage_tree.column("quantity", width=100)

        ing_scrollbar = ttk.Scrollbar(
            ingredient_frame,
            orient=tk.VERTICAL,
            command=self.ingredient_manage_tree.yview,
        )
        self.ingredient_manage_tree.configure(yscrollcommand=ing_scrollbar.set)

        self.ingredient_manage_tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        ing_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        self.ingredient_manage_tree.bind("<Double-1>", self.edit_ingredient_quantity)

        # 配置表格列和样式
        self._configure_columns()

        # 初始化数据
        self.load_categories()
        self.load_ingredients()
        self.search_recipes()

        # 绑定事件
        self.recipe_tree.bind("<<TreeviewSelect>>", self.show_ingredients)
        self.recipe_tree.bind("<Button-3>", self.show_context_menu)

        self.root.mainloop()

    def on_closing(self):
        # 窗口关闭时关闭数据库连接
        if hasattr(self, "conn"):
            try:
                self.conn.close()
                print("数据库连接已关闭")
            except:
                pass
        self.root.destroy()

    def _configure_columns(self):
        # 配置食谱列表列
        columns = {
            "ID": {"width": 60, "anchor": "center"},
            "名称": {"width": 200},
            "分类": {"width": 120},
            "卡路里": {"width": 80, "anchor": "center"},
            "状态": {"width": 100, "anchor": "center"},
        }

        for col, config in columns.items():
            self.recipe_tree.heading(col, text=col)
            self.recipe_tree.column(col, **config)

        # 配置食材详情列
        ingredient_columns = {
            "食材名称": {"width": 150},
            "所需数量": {"width": 80, "anchor": "center"},
            "库存": {"width": 80, "anchor": "center"},
        }

        for col, config in ingredient_columns.items():
            self.recipe_ingredient_tree.heading(col, text=col)
            self.recipe_ingredient_tree.column(col, **config)

        # 配置标签样式
        self.recipe_tree.tag_configure("unmade", background="#ffeeee")
        self.recipe_tree.tag_configure("sufficient", foreground="green")
        self.recipe_ingredient_tree.tag_configure("lack", background="#ffdddd")

    def load_categories(self):
        # 加载分类数据到下拉框
        try:
            query = """
                SELECT id, type_name 
                FROM dict 
                WHERE parent_id = 1
                ORDER BY sort_order
            """
            with self.conn.cursor() as cursor:
                cursor.execute(query)
                categories = [("全部(0)", 0)] + [
                    (f"{row['type_name']}({row['id']})", row["id"])
                    for row in cursor.fetchall()
                ]
                self.category_combo["values"] = [name for name, _ in categories]
                self.category_combo.set("全部(0)")
                self.category_map = {name: id for name, id in categories}
                print("分类加载成功")
        except Exception as e:
            messagebox.showerror("数据库错误", f"加载分类失败: {str(e)}")

    def search_recipes(self):
        # 搜索食谱并刷新表格
        selected = self.category_combo.get()
        category_id = selected.split("(")[-1].strip(")") if selected else "0"
        keyword = self.search_entry.get().strip()

        query = """
            SELECT r.id, r.name, d.type_name, r.calories, r.is_made
            FROM recipes r
            JOIN dict d ON r.category_id = d.id
            WHERE d.parent_id = 1
        """
        params = []

        if category_id != "0":
            query += " AND d.id = %s"
            params.append(category_id)

        if keyword:
            query += " AND r.name LIKE %s"
            params.append(f"%{keyword}%")

        query += " ORDER BY r.sort DESC"

        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, params)
                results = cursor.fetchall()

            self.recipe_tree.delete(*self.recipe_tree.get_children())
            for row in results:
                status = "已做" if row["is_made"] == 1 else "未做"
                tags = ("unmade",) if row["is_made"] == 2 else ()
                self.recipe_tree.insert(
                    "",
                    "end",
                    values=(
                        row["id"],
                        row["name"],
                        row["type_name"],
                        row["calories"],
                        status,
                    ),
                    tags=tags,
                )
            print(f"搜索到 {len(results)} 条食谱记录")
        except Exception as e:
            messagebox.showerror("查询失败", f"查询食谱失败: {str(e)}")

    def show_ingredients(self, event):
        # 显示选中食谱的食材详情
        selected = self.recipe_tree.selection()
        if not selected:
            return

        recipe_id = self.recipe_tree.item(selected[0], "values")[0]

        try:
            with self.conn.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT i.name, ri.quantity_required, i.quantity
                    FROM recipe_ingredients ri
                    JOIN ingredients i ON ri.ingredient_id = i.id
                    WHERE ri.recipe_id = %s
                """,
                    (recipe_id,),
                )
                ingredients = cursor.fetchall()

            self.recipe_ingredient_tree.delete(
                *self.recipe_ingredient_tree.get_children()
            )
            for ing in ingredients:
                tag = ("lack",) if ing["quantity"] < ing["quantity_required"] else ()
                self.recipe_ingredient_tree.insert(
                    "",
                    "end",
                    values=(ing["name"], ing["quantity_required"], ing["quantity"]),
                    tags=tag,
                )
            print(f"加载食谱 {recipe_id} 食材详情")
        except Exception as e:
            messagebox.showerror("加载失败", f"加载食材失败: {str(e)}")

    def check_ingredients(self):
        # 检查所有食谱食材是否充足
        for item in self.recipe_tree.get_children():
            recipe_id = self.recipe_tree.item(item, "values")[0]
            try:
                with self.conn.cursor() as cursor:
                    cursor.execute(
                        """
                        SELECT ri.quantity_required, i.quantity
                        FROM recipe_ingredients ri
                        JOIN ingredients i ON ri.ingredient_id = i.id
                        WHERE ri.recipe_id = %s
                    """,
                        (recipe_id,),
                    )
                    rows = cursor.fetchall()

                all_sufficient = all(
                    r["quantity"] >= r["quantity_required"] for r in rows
                )
                current_tags = list(self.recipe_tree.item(item, "tags"))
                if all_sufficient:
                    if "sufficient" not in current_tags:
                        current_tags.append("sufficient")
                else:
                    current_tags = [t for t in current_tags if t != "sufficient"]
                self.recipe_tree.item(item, tags=tuple(current_tags))
            except Exception as e:
                messagebox.showerror("检查失败", f"检查食材失败: {str(e)}")

    def show_context_menu(self, event):
        # 右键菜单用于修改食谱状态
        item = self.recipe_tree.identify_row(event.y)
        if item:
            menu = tk.Menu(self.root, tearoff=0)
            current_status = self.recipe_tree.item(item, "values")[4]
            if current_status == "已做":
                menu.add_command(
                    label="标记为未做",
                    command=lambda: self.update_recipe_status(item, 2),
                )
            else:
                menu.add_command(
                    label="标记为已做",
                    command=lambda: self.update_recipe_status(item, 1),
                )
            menu.post(event.x_root, event.y_root)

    def update_recipe_status(self, item, new_status):
        # 更新食谱状态到数据库
        recipe_id = self.recipe_tree.item(item, "values")[0]
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(
                    "UPDATE recipes SET is_made = %s WHERE id = %s",
                    (new_status, recipe_id),
                )
            self.conn.commit()
            self.search_recipes()
            print(f"食谱 {recipe_id} 状态更新为 {new_status}")
        except Exception as e:
            messagebox.showerror("更新失败", f"更新状态失败: {str(e)}")

    def load_ingredients(self):
        # 加载食材管理表数据
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(
                    "SELECT name, quantity FROM ingredients ORDER BY sort ASC"
                )
                rows = cursor.fetchall()

            self.ingredient_manage_tree.delete(
                *self.ingredient_manage_tree.get_children()
            )
            for row in rows:
                self.ingredient_manage_tree.insert(
                    "", "end", values=(row["name"], row["quantity"])
                )
            print("食材管理数据加载完成")
        except Exception as e:
            messagebox.showerror("加载失败", f"加载食材失败: {str(e)}")

    def edit_ingredient_quantity(self, event):
        # 双击修改食材数量
        item = self.ingredient_manage_tree.selection()[0]
        values = self.ingredient_manage_tree.item(item, "values")
        new_quantity = simpledialog.askfloat(
            "修改数量",
            "请输入新数量:",
            initialvalue=values[1],
            minvalue=0,
            maxvalue=1000,
        )
        if new_quantity is not None:
            try:
                with self.conn.cursor() as cursor:
                    cursor.execute(
                        "UPDATE ingredients SET quantity = %s WHERE name = %s",
                        (new_quantity, values[0]),
                    )
                self.conn.commit()
                self.load_ingredients()
                print(f"食材 {values[0]} 数量更新为 {new_quantity}")
            except Exception as e:
                messagebox.showerror("更新失败", f"修改数量失败: {str(e)}")
                self.conn.rollback()

    def sort_ingredients(self, col):
        # 食材表排序功能
        data = [
            (self.ingredient_manage_tree.set(k, col), k)
            for k in self.ingredient_manage_tree.get_children("")
        ]
        data.sort(key=lambda t: t[0])
        for index, (val, k) in enumerate(data):
            self.ingredient_manage_tree.move(k, "", index)
        print(f"按 {col} 排序完成")


if __name__ == "__main__":
    RecipeApp()
