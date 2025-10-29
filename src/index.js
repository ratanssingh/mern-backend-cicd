const express = require('express');
const api = require('./api');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use('/api', api);

app.get('/', (req, res) => res.send('MERN backend CI demo running'));

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
  });
}

module.exports = app; // export for testing
