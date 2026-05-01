###دليل التشغيل المحلي  على xamp###

```
alshefa/          ← ضع هذا المجلد في htdocs
├── index.html         ← لوحة التحكم الرئيسية
├── clinic.sql         ← ملف قاعدة البيانات
└── api/
    ├── config.php
    ├── patients.php
    ├── doctors.php
    ├── appointments.php
    ├── prescriptions.php
    ├── invoices.php
    └── stats.php
    └── auth_check.php
    └── login.php
    └── logout.php
```

---

## خطوات التثبيت

### 1. نسخ الملفات
## اولا اغط كليك يمين و بعدها اختار فايل لوكيشن (open file location) بعدها اضغط عليها و فتش مجلد
 ## htdocs   خش المجلد و اتبع الخطوات التالية 

انسخ مجلد `alshefa` كاملاً إلى:
```
C:\xampp\htdocs\alshefa\
```

### 2. تشغيل XAMPP
- افتح XAMPP Control Panel
- شغّل **Apache** و **MySQL**

### 3. إنشاء قاعدة البيانات
افتح المتصفح وانتقل إلى:
```
http://localhost/phpmyadmin
```
ثم:
1. انقر على **"New"** في الشريط الجانبي
2. في خانة **"SQL"** الخاصة بالاستيراد، انقر على **Import**
3. اختر ملف `clinic.sql`
4. انقر **import**

**أو بديلاً:**
1. في phpMyAdmin اضغط على **SQL**
2. انسخ محتوى `clinic.sql` كاملاً والصقه
3. اضغط **Go**

### 4. تشغيل النظام
افتح المتصفح وانتقل إلى:
```
http://localhost/alshefa/
```

---

## إعدادات قاعدة البيانات (api/config.php)

```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');    // اسم المستخدم الافتراضي في XAMPP
define('DB_PASS', '');        // كلمة المرور (فارغة افتراضياً)
define('DB_NAME', 'ahmed_clinic');
```



---

## ميزات النظام

| الوحدة | الوصف |
|--------|-------|
| **لوحة التحكم** | إحصائيات لحظية، مواعيد اليوم، الإيرادات |
| **المرضى** | إضافة / تعديل / حذف / بحث |
| **الأطباء** | إدارة بيانات الأطباء والتخصصات |
| **المواعيد** | حجز + فلتر بالتاريخ + إنشاء فاتورة تلقائي |
| **الوصفات** | ربط الأدوية بالمواعيد |
| **الفواتير** | متابعة المدفوعات + تعديل حالة الدفع |

---

## قاعدة البيانات ERD

```
patients ──< appointments >── doctors
                  │
                  ├──< prescriptions
                  │
                  └──1 invoice
```

---

## تقنيات المستخدمة
- **Frontend:** HTML5 + CSS3 + JavaScript (Vanilla) — Arabic RTL
- **Backend:** PHP 8 + PDO
- **Database:** MySQL (XAMPP)
- **Font:** Cairo (Google Fonts)

---

*مع تحيات طلاب جامعة امدرمان الاسلامية | الفرقة الثانية*