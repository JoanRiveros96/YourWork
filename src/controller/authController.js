const {Router} = require('express')
const router=  Router();    

const faker = require('faker');

const User= require('../models/userModel')
const verifyToken = require('./verifyToken')
const Worker = require('../models/workerModel');

const jwt  = require('jsonwebtoken')
const config = require('../config')

const workerController = require('../controller/workerController')

router.post('/signup', async(req,res) =>{
    try{



        const   {nombre, cc,ubicacion,celular, email,password } = req.body;
        const user = new User({
            nombre,
            cc,
            ubicacion,
            celular,                    
            email,
            password
        });
        user.password = await  user.encryptPassword(password);
        await user.save();

        const token = jwt.sign({id:user.id}, config.secret,{
            expiresIn:'24h'
        });
        res.status(200).json({auth: true , token});

        
    }catch (e){
        console.log(e)
        res.status(500).send('There was a problem signup');
    }
});

//CREACION DE USUARIOS Y TRABAJOS FAKER
// router.get('/user/create',  async(req,res) => {
//     // for(let i= 0; i<5; i++){
//     //     await User.create({
//     //         nombre: faker.name.firstName(),
//     // cc: '1232132',
//     // Avatar: faker.image.avatar(),
//     // ubicacion: faker.address.streetAddress(),
//     // celular: '2374253423',
//     // email: faker.internet.email(),
//     // password: faker.internet.password()
//     //     })
//     // }
//     // res.json("Create 5 users");


//         await User.create({
//             nombre: 'Joan Riveros',
//     cc: '1232132',
//     Avatar: faker.image.avatar(),
//     ubicacion: faker.address.streetAddress(),
//     celular: '2374253423',
//     email: 'admin@gmail.com',
//     password: '123456789'
//         })
    
//     res.json("Create admin user");

// });

// router.get('/worker/create',  async(req,res) => {
//     for(let i= 0; i<5; i++){
//         await Worker.create({

//         nombre : faker.name.firstName(),
//         cc : faker.random.number(),
//         Avatar : faker.image.avatar(),
//         ubicacion : faker.address.streetAddress(),
//         celular : faker.random.number(),
//        email : faker.internet.email(),
//        Antecedentes : faker.image.people(),
//        formacionPrincipal : faker.company.companyName(),
//        formacionSecundaria : faker.company.companyName(),
//        categoria : faker.commerce.department(),

//        //deberia generarse automaticamente
//        calificacion : faker.random.number()

        
//         })
//     }
//     res.json("5 trabajadores creados");



// });
/*router.route('/workers')
        .get(workerController.index)
        .post(workerController.new)

router.route('/worker/:id')
        .get(workerController.view)
        .put(workerController.update)
        .delete(workerController.delete)
*/
router.post('/signin', async (req,res)=>{
    try{

        const user = await User.findOne({email: req.body.email})
        if(!user){
            return res.status(404).send("The email doesn't exists")
        }
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if(!validPassword){
            return res.status(401).send({auth: false, token:null});
        }
        const token= jwt.sign({id:user._id}, config.secret,{
            expiresIn: '24h'
        });
        res.status(200).json({auth: true, token});

    }catch (e){
        console.log(e)
        res.status(500).send('There was a problem signin');
    }
});

router.get('/logout', function(req,res){
    res.status(200).send({auth:false, token:null});
});

module.exports = router;