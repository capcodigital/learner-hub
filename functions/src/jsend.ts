
export function successGetCertifs(values: any[]) {
    return successGetItems("certifications", values);
}

export function successGetUsers(values: any[]) {
    return successGetItems("users", values);
}

export function successGetSkills(values: any[]) {
    return successGetItems("skills", values);
}

export function successGetItems(title: string, values: any[]) {
    const json = {
        status: "success",
        "data": {
            [title]: values
        }
    };
    return JSON.stringify(json);
}

export function success() {
    const json = {
        status: "success",
        "data": null
    };
    return JSON.stringify(json);
}

export function fail(title: string, values: any) {
    const json = {
        status: "fail",
        "data": {
            [title]: values
        }
    };
    return JSON.stringify(json);
}

export function error(
    msg: string = "Error",
    statusCode: number = 500
) {
    const json = {
        status: "error",
        statusCode: statusCode,
        "message": msg
    };
    return JSON.stringify(json);
}