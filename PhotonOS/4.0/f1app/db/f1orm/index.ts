import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  const allDrivers = await prisma.drivers.findMany()
  console.log(allDrivers)
}

main()
  .catch((e) => {
    throw e
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
