# Vercel Deployment Guide for Waste Management System

## 📋 Prerequisites

- ✅ GitHub account with repository pushed
- ✅ Vercel account (free tier available)
- ✅ Node.js 18.x installed locally
- ✅ npm or yarn package manager

---

## 🚀 Step-by-Step Deployment Process

### **STEP 1: Prepare Your Repository**

1. Ensure all code is committed to GitHub
2. Verify `.env.example` is in repository (but `.env` is in `.gitignore`)
3. Check `vercel.json` is configured correctly
4. Your repository structure should have:
   ```
   waste-mgmt-repo/
   ├── frontend/          (React Vite app)
   ├── backend/           (PHP API - needs separate hosting)
   ├── .env.example
   ├── vercel.json
   └── create_waste_management_db.sql
   ```

---

### **STEP 2: Deploy Frontend to Vercel**

#### **Option A: Using Vercel Dashboard (Recommended for Beginners)**

1. **Go to Vercel.com**
   - Visit https://vercel.com
   - Sign in or create a free account

2. **Import Your Repository**
   - Click "Add New" → "Project"
   - Click "Import Git Repository"
   - Select your GitHub account
   - Search for "dbmsWasteManagement"
   - Click "Import"

3. **Configure Project Settings**
   - **Framework Preset:** Select "Vite"
   - **Root Directory:** Set to `./frontend`
   - **Build Command:** `npm run build`
   - **Output Directory:** `dist`
   - **Install Command:** `npm install`

4. **Set Environment Variables**
   - In "Environment Variables" section, add:
     ```
     VITE_API_BASE_URL = your-backend-url
     VITE_APP_NAME = Waste Management System
     VITE_APP_VERSION = 1.0.0
     ```

5. **Deploy**
   - Click "Deploy"
   - Wait for build to complete (2-3 minutes)
   - Your app will be live at `https://your-app.vercel.app`

---

#### **Option B: Using Vercel CLI (Advanced)**

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**
   ```bash
   vercel login
   ```

3. **Deploy from Project Root**
   ```bash
   cd /Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/waste-mgmt-repo
   vercel
   ```

4. **Follow prompts:**
   - Confirm project name
   - Set root directory to `./frontend`
   - Select production deployment
   - Add environment variables when prompted

5. **Verify Deployment**
   - Vercel will provide a URL
   - Your app is now live!

---

### **STEP 3: Deploy Backend API (Separate Hosting Required)**

Since Vercel is primarily for frontend, PHP backend needs different hosting:

#### **Option A: Use Heroku (Recommended for PHP)**

1. **Sign up at Heroku.com**
   - Create free account at https://www.heroku.com

2. **Install Heroku CLI**
   ```bash
   brew tap heroku/brew && brew install heroku
   ```

3. **Login to Heroku**
   ```bash
   heroku login
   ```

4. **Create Procfile** (in root directory)
   ```
   web: cd backend && php -S 0.0.0.0:$PORT router.php
   ```

5. **Create composer.json** (in backend directory)
   ```json
   {
     "require": {},
     "require-dev": {}
   }
   ```

6. **Deploy to Heroku**
   ```bash
   git add Procfile composer.json
   git commit -m "Add Heroku deployment files"
   git push heroku main
   ```

7. **Get Heroku URL**
   - Your backend will be at `https://your-app.herokuapp.com`

#### **Option B: Use Alternative Services**
- **Railway.app** - Modern alternative to Heroku
- **Render.com** - Free tier available
- **Replit** - Quick PHP hosting
- **Your own VPS** - AWS, DigitalOcean, Linode

---

### **STEP 4: Set Up Database**

#### **Option A: Use Managed MySQL (Recommended)**

1. **Use PlanetScale (MySQL hosting)**
   - Go to https://planetscale.com
   - Sign up for free account
   - Create new database
   - Get connection string

2. **Or use AWS RDS**
   - https://aws.amazon.com/rds/
   - Create MySQL instance
   - Get endpoint and credentials

3. **Or use Railway.com**
   - Create MySQL database
   - Get connection details

#### **Option B: Use Local Database**

- Keep database on your local machine
- Use ngrok to tunnel: `ngrok http 3306`
- Update connection strings in backend

---

### **STEP 5: Connect Everything Together**

1. **Update Frontend Environment Variables**
   - In Vercel Dashboard → Settings → Environment Variables
   - Set `VITE_API_BASE_URL` to your backend URL:
     ```
     https://your-backend.herokuapp.com
     ```

2. **Update Backend CORS Settings**
   - Edit `backend/config/cors.php`:
     ```php
     $allowed_origins = [
       'https://your-app.vercel.app',
       'http://localhost:3000'
     ];
     ```

3. **Update Database Configuration**
   - Edit `backend/config/Database.php`:
     ```php
     private $host = 'your-db-host.com';
     private $user = 'your-db-user';
     private $password = 'your-db-password';
     private $database = 'wasteManagement';
     ```

4. **Deploy Backend**
   ```bash
   git add .
   git commit -m "Update production environment variables"
   git push heroku main
   ```

---

### **STEP 6: Verify Deployment**

1. **Test Frontend**
   ```bash
   # Visit your Vercel URL
   https://your-app.vercel.app
   ```

2. **Test Backend Connection**
   ```bash
   # Should return API info
   curl https://your-backend.herokuapp.com
   ```

3. **Test API Endpoints**
   ```bash
   # Get areas
   curl https://your-backend.herokuapp.com/areas
   ```

4. **Create Test Data**
   ```bash
   # Add sample data
   mysql -h your-db-host -u your-user -p your-password wasteManagement < create_waste_management_db.sql
   ```

---

## 📊 Complete Architecture After Deployment

```
Internet Users
    ↓
    ├─→ Frontend (Vercel)
    │   └─→ https://your-app.vercel.app
    │
    └─→ Backend API (Heroku/Railway)
        └─→ https://your-backend.herokuapp.com
            ↓
            Database (PlanetScale/RDS)
            └─→ your-db-host.com:3306
```

---

## 🔒 Security Checklist

- ✅ `.env` file in `.gitignore` (never commit secrets)
- ✅ Database password not in code
- ✅ CORS properly configured
- ✅ SSL/TLS enabled (automatic on Vercel/Heroku)
- ✅ Environment variables set in deployment platforms
- ✅ Database backups enabled
- ✅ API keys secured

---

## 🐛 Troubleshooting

### **Frontend loads but no data shows**
- Check `VITE_API_BASE_URL` environment variable
- Verify backend is running
- Check CORS settings in backend
- Open browser console (F12) for errors

### **Backend API errors**
- Verify database connection
- Check credentials in `Database.php`
- Review error logs: `heroku logs --tail`
- Test database manually: `mysql -h host -u user -p`

### **Build fails on Vercel**
- Check `vercel.json` configuration
- Verify `package.json` has all dependencies
- Run `npm install` locally to test
- Check Node.js version compatibility

### **Database connection fails**
- Verify connection string is correct
- Check firewall rules allow connection
- Test connection locally first
- Use MySQL client to verify access

---

## 📝 Environment Variables Checklist

### Frontend (`VITE_*`)
- [ ] `VITE_API_BASE_URL` - Backend API URL
- [ ] `VITE_APP_NAME` - Application name
- [ ] `VITE_APP_VERSION` - App version

### Backend
- [ ] `DB_HOST` - Database hostname
- [ ] `DB_USER` - Database username
- [ ] `DB_PASSWORD` - Database password
- [ ] `DB_NAME` - Database name
- [ ] `CORS_ORIGIN` - Frontend URL
- [ ] `API_PORT` - Backend port

---

## 🎯 Quick Deployment Summary

1. **Frontend:** Push to GitHub → Import in Vercel → Done! (5 minutes)
2. **Backend:** Deploy to Heroku/Railway (10 minutes)
3. **Database:** Set up PlanetScale/RDS (5 minutes)
4. **Connect:** Update environment variables (5 minutes)
5. **Test:** Verify all connections work (5 minutes)

**Total Time: ~30 minutes**

---

## 💡 Pro Tips

- Use Vercel's preview deployments for testing before production
- Enable auto-deploy on every GitHub push
- Use monitoring tools: Sentry for errors, New Relic for performance
- Set up automated backups for your database
- Use GitHub Actions for automated testing
- Monitor API response times and errors

---

## 🔗 Useful Links

- **Vercel Docs:** https://vercel.com/docs
- **Heroku Docs:** https://devcenter.heroku.com
- **PlanetScale Docs:** https://docs.planetscale.com
- **Railway Docs:** https://docs.railway.app
- **React Vite Docs:** https://vitejs.dev

---

## ❓ Next Steps After Deployment

1. Monitor application performance
2. Set up error tracking (Sentry)
3. Configure analytics
4. Set up email notifications
5. Plan database scaling strategy
6. Create backup automation
7. Document production environment
8. Plan CI/CD pipeline

---

**Happy Deploying! 🚀**

Your Waste Management System is now production-ready!
