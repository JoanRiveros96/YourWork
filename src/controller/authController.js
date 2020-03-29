const {Router} = require('express')
const router=  Router();    

const User= require('../models/userModel')
const verifyToken = require('./verifyToken')

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