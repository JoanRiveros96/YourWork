let mongoose = require ('mongoose')

let workerSchema = mongoose.Schema({
    nombre:String,
    cc: Number,
    Avatar: String,
    ubicacion: String,
    celular: Number,
    email: String,
    Antecedentes: String,
    categoria: String,
    formacionPrincipal: String,
    formacionSecundaria: String,
    calificacion: Number,
    
    create: {
        type: Date,
        default: Date.now
    }
})
let Worker = module.exports =mongoose.model('worker', workerSchema);

module.exports.get = function(callback , limit){
    Worker.find(callback).limit(limit);
}