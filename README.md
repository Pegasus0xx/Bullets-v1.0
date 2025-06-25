# 🎯 Bullets v1.0

**Bullets** is a powerful tool for **static analysis** of Android applications using `apktool` and `nuclei`.

---

## ⚙️ Requirements

### 🔹 1. Install `apktool`

#### ▪️ Linux

Download the Linux [wrapper script](https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/windows/apktool.bat). (Right click, Save Link As `apktool`)
Download the [latest version](https://bitbucket.org/iBotPeaches/apktool/downloads) of Apktool.
Rename the downloaded jar to `apktool.jar`.
Move both `apktool.jar` and `apktool` to `/usr/local/bin`. (root needed)
Make sure both files are executable. `(chmod +x)`
Try running `apktool` via CLI.

#### ▪️ macOS

Download the Mac [wrapper script](https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/osx/apktool). (Right click, Save Link As `apktool`)
Download the [latest version](https://bitbucket.org/iBotPeaches/apktool/downloads) of Apktool.
Rename the downloaded jar to `apktool.jar`.
Move both `apktool.jar` and `apktool` to `/usr/local/bin`. (root needed)
Make sure both files are executable. `(chmod +x)`
Try running `apktool` via CLI.

#### ▪️ Using Homebrew (macOS/Linux)

Install Homebrew as described [in this page](https://brew.sh/).
Execute the command `brew install apktool` in the terminal.
Try running `apktool` via CLI.

---

### 🔹 2. Install `nuclei`

You can install it in one of two ways:

#### 🅐 Go install:

```bash
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@3.3.5
```

#### 🅑 Manual method:

```bash
wget https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.3.5.zip; \
unzip v3.3.5.zip; \
cd nuclei-3.3.5/cmd/nuclei; \
go build; \
mv nuclei /usr/local/bin/; \
nuclei -version;
```

> ⚠️ **Note:** Make sure `Go (Golang)` is installed and in your `$PATH`.
> Also, make sure to install `nuclei` version **3.3.5**.

---

## 🚀 How to Use

### 🔸 1. Copy the templates:

```bash
cp -r Templates $HOME/
```

### 🔸 2. Make the script executable:

```bash
chmod +x bullets.sh
```

### 🔸 3. Run the script:

```bash
./bullets.sh <APK_FILE>
```

---

## 📸 Screenshot

![Bullets Screenshot](https://github.com/Pegasus0xx/Bullets-v1.0/blob/main/img.jpg?raw=true)

![Bullets Screenshot](https://github.com/Pegasus0xx/Bullets-v1.0/blob/main/http_credentials.png?raw=true)

---

## 💬 Contact

For suggestions, issues, or contributions, feel free to open an issue or PR.
