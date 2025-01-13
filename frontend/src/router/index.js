import { createRouter, createWebHistory } from 'vue-router'

import DefaultLayout from '@/layouts/DefaultLayout.vue';

// const routes = [
//   {
//     path: '/',
//     name: 'home',
//     component: DefaultLayout,
//   },
//   {
//     path: '/about',
//     name: 'about',
//     component: function () {
//       return import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
//     }
//   },
//   {
//     path: '/OT',
//     name: 'overtime',
//     component: function () {
//       return import(/* webpackChunkName: "about" */ '../views/OvertimeView.vue')
//     }
//   },
//     {
//     path: '/test',
//     name: 'test',
//     component: function () {
//       return import(/* webpackChunkName: "about" */ '../components/ProjectList.vue')
//     }
//   }
// ]

const routes = [
  {
    path: '/',
    name: 'Home',
    component: DefaultLayout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'about',
        component: () => import('@/views/AboutView.vue'),
      },
      {
        path: '/overtime-form',
        name: 'OvertimeForm',
        component: () => import('@/views/OvertimeView.vue')
      },
    ],
  },
  {
    path: '/overtime-form',
    name: 'Overtime Request',
    component: DefaultLayout,
    redirect: '/overtime-form',
    children: [
      {
        path: 'overtime-form',
        name: 'OvertimeView',
        component: () => import('@/views/AboutView.vue'),
      },
    ],
  },
  {
    path: '/data',
    name: 'Data',
    component: DefaultLayout,
    redirect: '/data/overtime-analytics',
    children: [
      {
        path: 'overtime-analytics',
        name: 'OvertimeAnalytics',
        component: () => import('@/views/AboutView.vue'),
      },
      {
        path: 'overtime-history',
        name: 'OvertimeHistory',
        component: () => import('@/views/AboutView.vue'),
      },
      {
        path: 'employees',
        name: 'Employees',
        component: () => import('@/components/EmployeeList.vue'),
      },
      {
        path: 'projects',
        name: 'Projects',
        component: () => import('@/components/ProjectList.vue'),
      },
    ],
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'Page404',
    component: () => import('@/views/pages/Error404View.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  scrollBehavior() {
    return { top: 0 };
  },
})

export default router
