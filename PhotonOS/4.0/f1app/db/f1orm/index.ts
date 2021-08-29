import { PrismaClient } from '@prisma/client'
import express from 'express'

const prisma = new PrismaClient()
const app = express()

app.get('/drivers', async (req, res) => {
  const drivers = await prisma.drivers.findMany()
  res.json(drivers)
})

const server = app.listen(3000, () =>
  console.log(`
    Server ready at http://localhost:3000`,),
)
