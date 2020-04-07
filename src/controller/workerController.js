const {Router} = require('express')
const router=  Router();   

const Worker = require('../models/workerModel');



//const Worker = require('../models/workerModel')


exports.index = (req,res)=>{
    Worker.get((err, worker)=>{
        if(err){
            res.json({
                status:'err',
                code: 500,
                message: err
            });
        }
        res.json(worker);
    })
}


exports.new = function(req,res){
    let worker = new Worker()
    worker.nombre =req.body.nombre
    worker.cc = req.body.cc
    Worker.Avatar = req.body.Avatar
    worker.ubicacion = req.body.ubicacion
    worker.celular = req.body.celular
    worker.email = req.body.email
    worker.Antecedentes = req.body.Antecedentes
    worker.formacionPrincipal = req.body.formacionPrincipal
    worker.formacionSecundaria = req.body.formacionSecundaria
    worker.categoria = req.body.categoria

    //deberia generarse automaticamente
    worker.calificacion = req.body.calificacion

    worker.save(function (err){
        if(err){
            res.json({
                status:'err',
                code: 500,
                message: err
            })
        }
        res.json({
            status:'success',
            code: 200,
            message: 'worker save',
            data: worker
        })


    })
}

exports.view = function(req,res){
    Worker.findById(req.params.id, function(err,worker){
        if(err){
            res.json({
                status:'err',
                code: 500,
                message: err
            })
        }
        res.json({
            status:'success',
            code: 200,
            message: 'worker find',
            data: worker
        })
    })
}


exports.update = function(req,res){
    Worker.findById(req.params.id, function(err,worker){
        if(err){
            res.json({
                status:'err',
                code: 500,
                message: err
            })
            worker.nombre =req.body.nombre
            worker.cc = req.body.cc
            Worker.Avatar = req.Avatar
            worker.ubicacion = req.body.ubicacion
            worker.celular = req.body.celular
            worker.email = req.body.email
            worker.Antecedentes = req.body.Antecedentes
            worker.formacionPrincipal = req.body.formacionPrincipal
            worker.formacionSecundaria = req.body.formacionSecundaria
            worker.categoria = req.body.categoria
            worker.calificacion = req.body.calificacion
            worker.save(function (err){
                if(err){
                    res.json({
                        status:'err',
                        code: 500,
                        message: err
                    })
                }
                res.json({
                    status:'success',
                    code: 200,
                    message: 'worker update',
                    data: worker
                })
        
        
            })
        }
        
    })
}

exports.delete= function(res,req){
    worker.remove({
        _id: req.params.id
    },function(err){
        if(err)
            res.json({
                status: 'err',
                code: 500,
                message:err
            })
        res.json({
            status: 'success',
            code:200,
            message: 'worker delete'
        })
        
    })
}
module.exports = router;