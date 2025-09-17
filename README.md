
# 🇲🇾 Malaysia Living Cost & Savings Calculator

[![Flutter](https://img.shields.io/badge/Flutter-3.13-blue?logo=flutter\&logoColor=white)](https://flutter.dev/) [![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A **Flutter Web App** to help residents in Malaysia calculate monthly expenses, plan savings, and visualize spending patterns. Supports **single, married, and families with kids**, with lifestyle-based expense adjustments and export options.

---

## 🌐 Live Demo

[Open the Web App](#)
*(Replace `#` with your deployed web URL)*

---

## ✅ Features

* **Family Type Selection:** Single, Married, Married + 1 Kid, Married + 2 Kids.
* **Income Input:** Monthly income after tax.
* **Expense Categories:** Auto-filled by family type:

  * Rent, Utilities (Water, Electricity, Internet, Mobile)
  * Groceries, Vegetables, Fruits, Gas Cylinder
  * Eating Out, Drinking, Smoking
  * Entertainment, Weekly Outing, Temple Donation
  * Transport, Child Education, Medical, Clinic, Netflix, Prime, TV Channel
  * Custom “Other” expenses
* **Lifestyle Choices:** Checkboxes for drinking, smoking, outings, temple visits.
* **Edit Expenses:** Update any expense manually.
* **Visualizations:**

  * Pie chart of expense distribution
  * Bar chart of monthly savings projection (12 months)
* **Export Reports:**

  * PDF
  * Excel
* **Social Media & Promotions:**

  * YouTube: [Niki Bhavi Vlogs](https://www.youtube.com/@nikibhavi)
  * GitHub: [jssuthahar](https://github.com/jssuthahar)
  * Instagram: [nikibhavi](https://www.instagram.com/nikibhavi/)

---

## 🛠 Installation

```bash
git clone <your-repo-url>
cd malaysialivingcost
flutter pub get
flutter run -d chrome
```

**Release Build for Web:**

```bash
flutter build web --release
```

Build output: `build/web`

---

## 🧰 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  fl_chart: ^0.60.0
  pdf: ^3.11.0
  printing: ^5.12.0
  excel: ^2.0.8
  url_launcher: ^6.1.7
```

* **fl\_chart**: Pie and Bar charts visualization
* **pdf & printing**: Generate PDF reports
* **excel**: Export Excel sheets
* **url\_launcher**: Open social media links

---

## 📊 Screenshots

| Home Screen                   | Expense Calculator                        | Export Reports                    |
| ----------------------------- | ----------------------------------------- | --------------------------------- |
| ![Home](screenshots/home.png) | ![Calculator](screenshots/calculator.png) | ![Export](screenshots/export.png) |

*(Add your screenshots in `screenshots/` folder and update paths)*

---

## 🔧 Usage

1. Open the app in a browser.
2. Select **family type**.
3. Enter **monthly income**.
4. Adjust lifestyle choices (Drinking, Smoking, Outings, Temple visits).
5. Edit or review expenses.
6. View **total expenses**, **monthly savings**, and **yearly savings**.
7. Analyze **pie chart** for distribution and **bar chart** for projection.
8. Export reports as **PDF** or **Excel**.

---

## 📢 SEO Meta Tags (for Web)

```html
<title>Malaysia Living Cost & Savings Calculator</title>
<meta name="description" content="Plan Malaysia monthly expenses, family budget, and savings with an interactive Flutter web app. Includes visualization, PDF/Excel export, and lifestyle adjustments.">
<meta name="keywords" content="Malaysia living cost, expense calculator, savings planner, family budget, Flutter web, PDF export, Excel export, monthly expenses, kids, single, married">
<meta name="author" content="Niki Bhavi">
```

---

## 💻 Author & Socials

* **YouTube:** [Niki Bhavi Vlogs](https://www.youtube.com/@nikibhavi)
* **GitHub:** [jssuthahar](https://github.com/jssuthahar)
* **Instagram:** [nikibhavi](https://www.instagram.com/nikibhavi/)

---

## 📄 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

