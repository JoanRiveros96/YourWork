const mongoose = require('mongoose')

mongoose.connect('mongodb://localhost:27017/YourWorkdb',{
 
    useNewUrlPaerser: true,
    useUnifiedTopology: true, 
    useCreateIndex: true

}).then(db => console.log('connection established succesfully'))