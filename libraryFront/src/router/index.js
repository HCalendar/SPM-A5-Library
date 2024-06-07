import { createRouter, createWebHistory } from 'vue-router'
import Layout from "../layout/Layout";

const routes = [
  {
    path: '/',
    name: 'Layout',
    redirect:"user",
    component: Layout,
    children:[
      {
        path:'user',
        name:'user',
        component:() => import("@/views/User")
      },
      {
        path: 'book',
        name: 'book',
        component: () => import("@/views/Book")
      },
      {
        path: 'person',
        name: 'Person',
        component: () => import("@/views/Person")
      },
      {
        path: 'password',
        name: 'Password',
        component: () => import("@/views/Password")
      },
      {
        path: 'lendrecord',
        name: 'LendRecord',
        component: () => import("@/views/LendRecord")
      },
      {
        path:'dashboard',
        name:'Dashboard',
        component:() => import("@/views/Dashboard")
      },
      {
        path: 'favorites',
        name: 'Favorites',
        component: () => import("@/views/Favorites")
      },
      {
        path: 'bookwithuser',
        name: 'BookWithUser',
        component: () => import("@/views/BookWithUser")
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import("@/views/Login")
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import("@/views/Register")
  },
  {
    path: '/guest',
    name: 'Guest',
    component: () => import("@/views/Guest")
  },
  {
    path: '/comment/:bookname/:bookid',
    name: 'Comment',
    component: ()=>import("@/views/Comment")
  },
  {
    path: '/penalty/:money/:id',
    name: 'Penalty',
    component: ()=>import("@/views/Penalty")
  },
  {
    path: '/feedback',
    name: 'Feedback',
    component: ()=>import("@/views/Feedback")
  },
  {
    path:'/bookTest',
    name:'BookTest',
    component: ()=>import("@/views/BookTest")
  }

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
