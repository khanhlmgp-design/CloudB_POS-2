"""
Cloud B Convenience POS v1.0.0 - Demo main.py
Chạy: python main.py
Lưu ý: Đây là bản demo sẵn sàng để đóng gói .exe bằng PyInstaller.
"""
import os, sqlite3, json
from datetime import datetime, date
try:
    import customtkinter as ctk
except Exception as e:
    raise SystemExit("Thiếu customtkinter. Cài đặt: pip install customtkinter\n"+str(e))
from tkinter import messagebox, filedialog
from PIL import Image, ImageTk

DB = os.path.join("database","pos_demo.db")
CFG = "config.json"

def get_conn(): return sqlite3.connect(DB)

def load_config():
    if os.path.exists(CFG):
        with open(CFG,"r",encoding="utf-8") as f: return json.load(f)
    return {}

def verify_user(u,p):
    conn = get_conn(); c = conn.cursor()
    c.execute("SELECT username,role,fullname FROM users WHERE username=? AND password=?", (u,p))
    r = c.fetchone(); conn.close(); return r

ctk.set_appearance_mode("System"); ctk.set_default_color_theme("blue")

class Login(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Cloud B Convenience POS - Đăng nhập")
        self.geometry("640x420")
        cfg = load_config()
        logo = cfg.get("logo","assets/CLOUBLOGO.png")
        try:
            img = Image.open(logo).resize((240,80)); self.logo_img = ImageTk.PhotoImage(img); ctk.CTkLabel(self,image=self.logo_img,text="").pack(pady=8)
        except: ctk.CTkLabel(self,text=cfg.get("store_name","Cloud B Convenience")).pack(pady=8)
        frm = ctk.CTkFrame(self); frm.pack(pady=12)
        ctk.CTkLabel(frm, text="Tên đăng nhập").grid(row=0,column=0); self.u = ctk.StringVar(); ctk.CTkEntry(frm, textvariable=self.u).grid(row=0,column=1)
        ctk.CTkLabel(frm, text="Mật khẩu").grid(row=1,column=0); self.p = ctk.StringVar(); ctk.CTkEntry(frm, textvariable=self.p, show="*").grid(row=1,column=1)
        ctk.CTkLabel(self, text="(Mặc định: admin/1234 ; staff/0000)").pack(pady=6)
        ctk.CTkButton(self, text="Đăng nhập", command=self.login).pack(pady=6)
        self.bind("<Return>", lambda e: self.login())

    def login(self):
        r = verify_user(self.u.get().strip(), self.p.get().strip())
        if not r: messagebox.showerror("Lỗi","Tên đăng nhập hoặc mật khẩu không đúng"); return
        username,role,fullname = r
        self.destroy()
        app = POSApp(username, role, fullname); app.attributes('-fullscreen', True); app.mainloop()

class POSApp(ctk.CTk):
    def __init__(self, username, role, fullname):
        super().__init__()
        self.user=username; self.role=role; self.fullname=fullname
        self.title(f"Cloud B Convenience POS - {self.user} ({self.role})")
        self.geometry("1200x800")
        self.cfg = load_config()
        self.create_ui()

    def create_ui(self):
        self.sidebar = ctk.CTkFrame(self, width=220); self.sidebar.pack(side="left", fill="y", padx=8, pady=8)
        try:
            img = Image.open(self.cfg.get("logo","assets/CLOUBLOGO.png")).resize((180,60)); self.logo_img = ImageTk.PhotoImage(img); ctk.CTkLabel(self.sidebar,image=self.logo_img,text="").pack(pady=8)
        except: ctk.CTkLabel(self.sidebar, text=self.cfg.get("store_name","Cloud B Convenience")).pack(pady=8)
        buttons = [("Bán hàng", self.show_sale), ("Sản phẩm", self.show_products), ("Báo cáo", self.show_reports)]
        if self.role=="admin": buttons += [("Cài đặt", self.show_settings), ("Quản lý", self.show_admin)]
        for name,cmd in buttons: ctk.CTkButton(self.sidebar, text=name, command=cmd).pack(fill="x", padx=12, pady=6)
        ctk.CTkButton(self.sidebar, text="Đăng xuất", fg_color="#bf8a66", command=self.logout).pack(side="bottom", fill="x", padx=12, pady=12)
        top = ctk.CTkFrame(self, height=60); top.pack(side="top", fill="x", padx=8, pady=8); ctk.CTkLabel(top, text=f"{self.cfg.get('store_name','Cloud B Convenience')} - {self.cfg.get('version','')}").pack(side="left", padx=12)
        self.container = ctk.CTkFrame(self); self.container.pack(side="right", fill="both", expand=True, padx=8, pady=8)
        self.show_sale()

    def clear(self): 
        for w in self.container.winfo_children(): w.destroy()

    def show_sale(self):
        self.clear(); f = ctk.CTkFrame(self.container); f.pack(fill="both", expand=True)
        ctk.CTkLabel(f, text="Bán hàng - demo (nhập id|qty mỗi dòng)").pack(pady=6)
        self.cart = ctk.CTkTextbox(f, height=200); self.cart.pack(fill="x", padx=8, pady=6)
        ctk.CTkButton(f, text="Thanh toán", command=self.checkout).pack(pady=6)

    def show_products(self):
        self.clear(); f = ctk.CTkFrame(self.container); f.pack(fill="both", expand=True)
        ctk.CTkLabel(f, text="Quản lý sản phẩm - demo").pack(pady=6)
        self.p_name = ctk.StringVar(); self.p_price = ctk.StringVar(); self.p_stock = ctk.StringVar(); self.p_code = ctk.StringVar()
        frm = ctk.CTkFrame(f); frm.pack(pady=6)
        ctk.CTkLabel(frm, text="Tên").grid(row=0,column=0); ctk.CTkEntry(frm, textvariable=self.p_name).grid(row=0,column=1)
        ctk.CTkLabel(frm, text="Giá").grid(row=1,column=0); ctk.CTkEntry(frm, textvariable=self.p_price).grid(row=1,column=1)
        ctk.CTkLabel(frm, text="Tồn").grid(row=2,column=0); ctk.CTkEntry(frm, textvariable=self.p_stock).grid(row=2,column=1)
        ctk.CTkLabel(frm, text="Mã").grid(row=3,column=0); ctk.CTkEntry(frm, textvariable=self.p_code).grid(row=3,column=1)
        ctk.CTkButton(frm, text="Thêm SP", command=self.add_product_ui).grid(row=4,column=0,columnspan=2,pady=8)
        self.prod_box = ctk.CTkTextbox(f, height=300); self.prod_box.pack(fill="both", expand=True, padx=8, pady=6)
        self.refresh_products()

    def show_reports(self):
        self.clear(); f = ctk.CTkFrame(self.container); f.pack(fill="both", expand=True)
        ctk.CTkLabel(f, text="Báo cáo tài chính - demo").pack(pady=6)
        ctk.CTkButton(f, text="Tải báo cáo tháng", command=self.open_finance).pack(pady=6)

    def open_finance(self):
        top = ctk.CTkToplevel(self); top.title("Báo cáo tài chính"); top.geometry("900x600")
        ctk.CTkLabel(top, text="Báo cáo (demo)").pack(pady=6)
        mv = ctk.StringVar(value=date.today().strftime("%Y-%m")); ctk.CTkLabel(top, text="Tháng (YYYY-MM):").pack(); me = ctk.CTkEntry(top, textvariable=mv); me.pack()
        def load(): 
            month = mv.get(); conn = sqlite3.connect(DB); c = conn.cursor(); c.execute("SELECT SUM(total) FROM transactions WHERE substr(datetime,1,7)=?", (month,)); s=c.fetchone()[0] or 0
            c.execute("SELECT SUM(amount) FROM expenses WHERE substr(date,1,7)=?", (month,)); cost=c.fetchone()[0] or 0; profit=s-cost; vat=s*0.1; income_tax=profit*0.2 if profit>0 else 0
            messagebox.showinfo("Báo cáo", f"Doanh thu: {s:.2f}\\nChi phí: {cost:.2f}\\nLợi nhuận: {profit:.2f}\\nVAT: {vat:.2f}\\nTNDN: {income_tax:.2f}")
            conn.close()
        ctk.CTkButton(top, text="Tải", command=load).pack(pady=6)

    def show_settings(self):
        self.clear(); f = ctk.CTkFrame(self.container); f.pack(fill="both", expand=True)
        ctk.CTkLabel(f, text="Cài đặt chung (admin)").pack(pady=6)
        ctk.CTkButton(f, text="Thay logo", command=self.change_logo).pack(pady=6)
        ctk.CTkButton(f, text="Quản lý người dùng", command=self.manage_users).pack(pady=6)

    def manage_users(self):
        top = ctk.CTkToplevel(self); top.title("Quản lý người dùng"); top.geometry("600x400")
        conn = sqlite3.connect(DB); c = conn.cursor(); c.execute("SELECT id,username,role,fullname FROM users ORDER BY id"); rows=c.fetchall(); conn.close()
        txt = "\\n".join([f\"{r[0]} | {r[1]} | {r[2]} | {r[3]}\" for r in rows])
        ctk.CTkLabel(top, text=txt).pack()

    def change_logo(self):
        p = filedialog.askopenfilename(filetypes=[("Images","*.png;*.jpg;*.jpeg")]); 
        if not p: return
        dst = os.path.join("assets", os.path.basename(p)); import shutil; shutil.copyfile(p,dst)
        cfg = load_config(); cfg['logo']=dst; open(CFG,"w",encoding="utf-8").write(json.dumps(cfg,indent=2,ensure_ascii=False))
        messagebox.showinfo("OK","Logo đã cập nhật. Khởi động lại ứng dụng để thấy thay đổi.")

    def add_product_ui(self):
        try:
            price = float(self.p_price.get()); stock = int(self.p_stock.get())
        except:
            messagebox.showerror("Lỗi","Giá hoặc tồn không hợp lệ"); return
        conn = sqlite3.connect(DB); c = conn.cursor(); c.execute("INSERT INTO products (code,name,price,stock) VALUES (?,?,?,?)", (self.p_code.get(), self.p_name.get(), price, stock)); conn.commit(); conn.close(); messagebox.showinfo("OK","Đã thêm sản phẩm"); self.refresh_products()

    def refresh_products(self):
        try:
            conn = sqlite3.connect(DB); c = conn.cursor(); c.execute("SELECT id,code,name,price,stock FROM products ORDER BY name"); rows=c.fetchall(); conn.close()
            self.prod_box.delete("0.0","end")
            for r in rows: self.prod_box.insert("end", f\"{r[0]} | {r[2]} | {r[3]:.2f} | stock:{r[4]}\\n\")
        except: pass

    def checkout(self):
        lines = self.cart.get("0.0","end").strip().splitlines(); items=[]
        for ln in lines:
            parts=ln.split("|"); 
            if not parts: continue
            try:
                pid=int(parts[0].strip()); qty=int(parts[1].strip()) if len(parts)>1 else 1
                conn=sqlite3.connect(DB); c=conn.cursor(); c.execute("SELECT id,code,name,price,stock FROM products WHERE id=?", (pid,)); p=c.fetchone(); conn.close()
                if not p: continue
                items.append({'product_id':p[0],'name':p[2],'price':p[3],'qty':qty,'subtotal':round(p[3]*qty,2)})
            except: continue
        if not items: messagebox.showinfo("Info","Giỏ hàng trống"); return
        conn=sqlite3.connect(DB); c=conn.cursor(); total=sum(it['subtotal'] for it in items); c.execute("INSERT INTO transactions (datetime,type,total,shift_id,user) VALUES (?,?,?,?,?)", (datetime.now().isoformat(),"sale",total,1,self.user)); txn_id=c.lastrowid
        for it in items:
            c.execute("INSERT INTO transaction_items (txn_id,product_id,name,price,qty,subtotal) VALUES (?,?,?,?,?,?)", (txn_id,it.get('product_id'),it['name'],it['price'],it['qty'],it['subtotal'])); c.execute("UPDATE products SET stock = stock - ? WHERE id=?", (it['qty'], it['product_id']))
        conn.commit(); conn.close(); messagebox.showinfo("OK", f"Thanh toán thành công #{txn_id} - Tổng {total:.2f}"); self.cart.delete("0.0","end"); self.refresh_products()

    def show_admin(self):
        self.clear(); f = ctk.CTkFrame(self.container); f.pack(fill="both", expand=True); ctk.CTkLabel(f, text="Quản lý nâng cao - demo").pack(pady=6); ctk.CTkButton(f, text="Chi tiết Xóa/Hoàn hàng", command=self.show_detail_delete_refund).pack(pady=6)

    def show_detail_delete_refund(self):
        conn = sqlite3.connect(DB); c = conn.cursor(); c.execute("SELECT id,user,action,details,ts FROM activity_log WHERE action IN ('delete_product','txn_refund') ORDER BY ts DESC LIMIT 500"); rows = c.fetchall(); conn.close(); s = "Chi tiết Xóa/Hoàn hàng:\\n\\n"
        for r in rows: s+=f"{r[4]} | {r[1]} | {r[2]} | {r[3]}\\n"
        messagebox.showinfo("Chi tiết", s)

    def logout(self):
        self.destroy(); Login().mainloop()

if __name__ == "__main__":
    Login().mainloop()
