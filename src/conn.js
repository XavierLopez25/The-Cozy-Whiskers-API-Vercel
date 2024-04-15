import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.POSTGRES_URL + '?sslmode=require',
});

pool.connect((err) => {
  if (err) {
    console.log('Error connecting to Postgres:', err);
  } else {
    console.log('Connected to Postgres');
  }
});

export default pool;
