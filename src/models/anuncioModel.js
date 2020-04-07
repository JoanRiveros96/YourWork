let mongoose = require ('mongoose')

let anuncioSchema = mongoose.Schema({
    titulo:{
        type: String,
        require:true,
    },
    descripcion: String,
    categoria: String,
    valor: String,
    contact: Number,
    fecha: {
        type: Date,
        default: Date.now
    }
})
let anuncio = module.exports =mongoose.model('anuncio', anuncioSchema);

module.exports.get = function(callback , limit){
    anuncio.find(callback).limit(limit);
}