
export function successGetCertifs(values: any[]) {
    const title = values.length == 1 ? "certification" : "certifications";
    return successGetItems(title, values);
}

export function successGetUsers(values: any[]) {
    const title = values.length == 1 ? "user" : "users";
    return successGetItems(title, values);
}

export function successGetSkills(values: any[]) {
    const title = values.length == 1 ? "skill" : "skills";
    return successGetItems(title, values);
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

function successGetItems(title: string, values: any[]) {
    const json = {
        status: "success",
        "data": {
            [title]: values
        }
    };
    return JSON.stringify(json);
}