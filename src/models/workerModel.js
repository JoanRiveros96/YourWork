let mongoose = require ('mongoose')

let workerSchema = mongoose.Schema({
    nombre:{
        type: String,
        require:true,
    },
    cc: Number,
    categoria: String,
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