interface User {
    id: number,
    firstName: string,
    surname: string,
    jobTitle: string,
    confluenceConnected: Boolean,
    // skills: Skills
    bio: string,
    email: string,
    passwordHash: string
}