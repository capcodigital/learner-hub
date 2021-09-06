interface User {
    id: number,
    email: string,
    passwordHash: string,
    firstName: string,
    surname: string,
    jobTitle: string,
    bio: string,
    confluenceConnected: Boolean,
    // skills: Skills
}