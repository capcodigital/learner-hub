interface User {
    id: string,
    email: string,
    password: string,
    passwordHash: string,
    firstName: string,
    surname: string,
    jobTitle: string,
    bio: string,
    confluenceConnected: Boolean
    // skills: Skills
}