import data from '../test/catalog.json';

type Certification = {
    id: number;
    name: string;
    category: string;
    subcategory: string;
    url: string;
    contentUrl: string;
};

export const getUrl = (id: number): string => {
    const certFilter: Certification[] = data.filter((c: Certification) => c.id == id);
    console.log(certFilter);
    var url = (certFilter.length > 0) ? (certFilter[0].url) : ("");
    return url;
}

export const getById = (id: number): Certification => {
    const certFilter: Certification[] = data.filter((c: Certification) => c.id == id);
    return certFilter[0];
}