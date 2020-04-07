anuncio = require('../models/anuncioModel');

exports.index = (req,res)=>{
    anuncio.get((err, anuncio)=>{
        if(err){
            res.json({
                status:'err',
                code: 500,
                message: err
            });
        }
        res.json(anuncio);
    })
}


exports.new = function(req,res){
    let anuncio = new Worker()
    
    anuncio.titulo =req.body.titulo
    anuncio.descripcion = req.body.descripcion
    anuncio.categoria = req.body.categoria
    anuncio.valor = req.body.valor
    anuncio.contact = req.body.contact
    anuncio.fecha = req.body.fecha
   

   

    anuncio.save(function (err){
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
            message: 'anuncio guardado',
            data: worker
        })


    })
}

exports.view = function(req,res){
    anuncio.findById(req.params.id, function(err,anuncio){
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
            message: 'anuncio encontrado',
            data: anuncio
        })
    })
}


exports.update = function(req,res){
    anuncio.findById(req.params.id, function(err,anuncio){
        if(err){
            res.json({
                status:'err',
                code: 500,
                message: err
            })
            anuncio.titulo =req.body.titulo
    anuncio.descripcion = req.body.descripcion
    anuncio.categoria = req.body.categoria
    anuncio.valor = req.body.valor
    anuncio.contact = req.body.contact
    anuncio.fecha = req.body.fecha
   
            anuncio.save(function (err){
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
                    message: 'anuncio actualizado',
                    data: anuncio
                })
        
        
            })
        }
        
    })
}

exports.delete= function(res,req){
    anuncio.remove({
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
            message: 'anuncio eliminado'
        })
        
    })
}