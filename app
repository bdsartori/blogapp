// Carregando módulos

const express = require('express')
const Handlebars = require('express-handlebars')
const {allowInsecurePrototypeAccess} = require('@handlebars/allow-prototype-access')
const bodyParser = require('body-parser')
const app = express()
const admin = require('./routes/admin')
const path = require('path')
const mongoose = require('mongoose')
const session = require('express-session')
const flash = require('connect-flash')

const handlebars = Handlebars.create({
    defaultLayout: 'main', 
    extname: 'handlebars',
    handlebars: allowInsecurePrototypeAccess(Handlebars),
    allowedProtoMethods: {
        trim: true
      }
  });




//Configurações

    //Sessão
        app.use(session({
            secret: "cursodenode",
            resave: true,
            saveUninitialized: true,
        }))
        app.use(flash())

    //Middleware
        app.use((req, res, next) => {
            res.locals.success_msg = req.flash("success_msg")
            res.locals.error_msg = req.flash("error_msg")
            next()
        })

    //Body Parser
        app.use(bodyParser.urlencoded({extended: true}))
        app.use(bodyParser.json())

    //Handlebars
        app.engine('handlebars', Handlebars({defaultLayout: 'main'}))  
        app.set('view engine', 'handlebars');

    //Mongoose
        mongoose.Promise = global.Promise;
        mongoose.set('useUnifiedTopology', true);
            mongoose.connect('mongodb://localhost/blogapp', {useNewUrlParser: true}).then(() => {
                console.log("Conectado ao mongo")
            }).catch((err) => {
                console.log("Erro ao se conectar: "+err)
            })

    //Public
        app.use(express.static(path.join(__dirname,"public")))

        app.use((req, res,next) => {
            console.log("OI EU SOU UM MIDDLEWARE!")
            next()
        })

//Rotas
    app.get('/', (req, res) => {
        res.send('Rota principal')
    })
    app.get('/posts', (req, res) => {
        res.send('Lista de Posts')
    })
    app.use('/admin', admin)


//Outros

const PORT = 8083
app.listen(PORT, () => {
    console.log("Servidor rodando!")
})
