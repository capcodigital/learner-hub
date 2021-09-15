interface Descriptions {
    category: []
}

interface Category {
    cloud: Cloud
    security: Security
    blockchain: Blockchain
    mobile: Mobile
}

interface Cloud {
    platform: CloudPlatform[]
}

interface CloudPlatform {
    aws: Certificate[]
    gcp: Certificate[]
    hashicorp: Certificate[]
    azure: Certificate[]
    cncf: Certificate[]
    isc2: Certificate[]
}

interface Security {
    platform: SecurityPlatform[]
}

interface SecurityPlatform {
    udemy: Certificate[]
    'api academy': Certificate[]
}

interface Blockchain {
    platform: BlockchainPlatform[]
}

interface BlockchainPlatform {
    corda: Certificate[]
}

interface Mobile {
    platform: MobilePlatform[]
}

interface MobilePlatform {
    android: Certificate[]
}

interface Certificate {
    title: string,
    description: string
}