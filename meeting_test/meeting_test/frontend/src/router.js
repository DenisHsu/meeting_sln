

import { createRouter, createWebHistory } from 'vue-router';
import CompanyManager from './components/CompanyManager.vue';
const routes = [
    { path: '/', component: CompanyManager } 
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
