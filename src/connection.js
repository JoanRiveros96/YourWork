const mongoose = require('mongoose')

mongoose.connect('mongodb+srv://admin:YourWork@cluster0-mcpbb.mongodb.net/test?retryWrites=true&w=majority',{
 
    useNewUrlPaerser: true,
    useUnifiedTopology: true, 
    useCreateIndex: true

}).then(db => console.log('connection established succesfully'))