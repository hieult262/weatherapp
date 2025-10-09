import os
from flask import Flask, request, jsonify, session, redirect, url_for, render_template
from models import db, User, Weather
from config import config
from weather import get_weather
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__,template_folder="template")
app.config.from_object(config)

#Secret key cho session
app.secret_key= os.getenv("APP_SECRET")

# Initialize DB
db.init_app(app)

DEFAULT_CITIES = ["London","Ho Chi Minh","Tokyo","New York","Berlin","Bangkok"]

@app.route("/")
def index():
    message = session.pop("message",None)
    username = session.get("username", None)
    weather_data = []
    cities = []
    if username == "admin":
        return redirect(url_for("admin"))
    else: 
        if not username:
            cities = DEFAULT_CITIES
        else:
            users = User.query.filter_by(username=username).first()
            prefs = Weather.query.filter_by(user_id=users.id).order_by(Weather.id.desc()).limit(6).all()
            if users and prefs:
                for p in prefs:
                    cities.append(p.location)
            else:
                 cities = DEFAULT_CITIES
        for city in cities:         
            weather_data.append(get_weather(city))
        #weather_data = [get_weather(city) for city in cities]
        return render_template("index.html", message=message, username=username,weather_data=weather_data,cities=cities)
    
@app.route("/admin.html")
def admin():
    message = session.pop("message",None)
    username = session.pop("search_username", None)
    if username:
        users = User.query.filter(User.username.ilike(f"%{username}%")).order_by(User.id.asc()).all()
    else:
        users = User.query.order_by(User.id.asc()).all()
    return render_template("admin.html",message=message, username=username,users=users)

@app.route("/login.html")
def login_page():
    message = session.pop("message",None)
    return render_template("login.html", message=message)

@app.route("/register.html")
def register_page():
    message = session.pop("message", None)
    return render_template("register.html", message=message)

@app.route("/changepassword.html/<string:username>")
def changepassword_page(username):
    user= User.query.filter_by(username=username).first()
    return render_template("changepassword.html", username=user.username)

@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username")
    password = request.form.get("password")

    user = User.query.filter_by(username=username).first()
    if username == user.username and password == user.password:
        session["username"] = user.username
        session["message"] = "Login Successful"
        return redirect(url_for("index"))
    else:
        session["message"] = "Wrong username or password"
        return redirect(url_for("index"))
    
@app.route("/register", methods=["POST"])
def register():
    username = request.form.get("username")
    password = request.form.get("password")
    users= User.query.filter_by(username=username).first()
    if not username and not password:
        session["message"] = "Please enter both username and password"
        return redirect(url_for("register_page"))
    elif users:
        session["message"] = "User exists"
        return redirect(url_for("register_page"))
    else:
        user = User(username=username,password=password)
        db.session.add(user)
        db.session.commit()
        session["message"] = ("Register Successful")
    return redirect(url_for("login_page"))

@app.route("/logout", methods=["POST"])
def logout():
    session.pop("user_id", None)
    session.clear()
    session["message"] = "Logout Succesful"
    return redirect(url_for("index"))

@app.route("/admin/delete/<string:username>", methods=["POST"])
def delete_user(username):
    if username == "admin":
        session["message"] = "This account can't delete"
        return redirect(url_for("admin"))
    else:
        user = User.query.filter_by(username=username).first()
        db.session.delete(user)
        db.session.commit()
        session["message"] = "Delete account successful"
        return redirect(url_for("admin"))

@app.route("/admin/change_password", methods=["POST"])
def change_password():
    username = request.form.get("username")
    password = request.form.get("password")

    users = User.query.filter_by(username=username).first()
    if password:
        users.password =  password
        db.session.commit()
        session["message"] = "Update successful"
        return redirect(url_for("admin"))
    else:
        session["message"] = "Password is not empty"
        return redirect(url_for("changepassword_page"))
    
@app.route("/admin/search_username", methods=["GET"])
def searchUsername():
    username = request.args.get("username")
    session["search_username"] = username
    return redirect(url_for("admin"))

@app.route("/weather_update", methods=["POST"])
def update_location():
    username=session.get("username")
    city=request.form.get("cities").strip()
    print("Cities input: ", city)
    if not username:
        session["message"] = "Please login first"
        return redirect(url_for("index"))
    
    if not city:
        session["message"] = "You must update at least 1 city"
        return redirect(url_for("index"))
    
    users = User.query.filter_by(username=username).first()
    pref = Weather(user_id=users.id, location=city)
    db.session.add(pref)
    db.session.commit()
    session["message"] = "Update Successful"
    return redirect(url_for("index"))

if __name__== "__main__":
    with app.app_context():
        for i in range(10):  # Thử lại tối đa 10 lần
            try:
                db.session.execute("SELECT 1")
                print("✅ Database connection successful!")
                db.create_all()
                break
            except OperationalError as e:
                print(f"⚠️ Database not ready (attempt {i+1}/10): {e}")
                time.sleep(5)  # Chờ 5s rồi thử lại
        else:
            print("❌ Could not connect to database after multiple attempts.")
            exit(1)

    app.run(host="0.0.0.0", port="5000")