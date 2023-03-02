import { Unleash } from 'unleash-client';
import { configuration } from '../config/configuration';

const unleash = new Unleash({
    appName: 'default',
    url: 'http://mado.one:4242/api/',
    environment: configuration.isDev ? 'development' : 'production',
    customHeaders: {
        Authorization: configuration.isDev ? 'default:development.ca6f6aedded0f438f322966fd946811a20c826c4ad18897b26002092' : 'default:production.e257159ef8bbd1b07fd4f90458a4561e68e2f59390e32d58bda412ee'
        // Authorization: `default:development.unleash-insecure-api-token`,
    },
});

unleash.on('error', console.error);
export default unleash;