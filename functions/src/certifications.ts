import data from '../test/catalog.json';

type Certification = {
    id: number;
    name: String;
    category: String;
    subcategory: String;
    url: String;
    contentId: String;
};

export const getUrl = (id: number): String => {
    const certFilter: Certification[] = data.filter((c: Certification) => c.id == id);
    console.log(certFilter);
    var url = (certFilter.length > 0) ? (certFilter[0].url) : ("");
    return url;
}

export const getById = (id: number): Certification => {
    const certFilter: Certification[] = data.filter((c: Certification) => c.id == id);
    return certFilter[0];
}