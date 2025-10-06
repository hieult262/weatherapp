from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=True)
    password = db.Column(db.String(32), nullable=True)
    preferences= db.relationship("Weather", backref="user", lazy=True)

    def json(self):
        return {'id':self.id, 'username':self.username, 'password':self.password}
    
class Weather(db.Model):
    __tablename__= "Weather"
    id = db.Column(db.Integer, primary_key=True)
    location = db.Column(db.String(100), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey(User.id), nullable=False)

    def json(self):
        return {'id': self.id, 'location': self.location, 'user_id': self.user_id}