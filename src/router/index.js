import { createRouter, createWebHashHistory } from "vue-router";

import HomeView from "@/views/HomeView.vue";


const routes = [
  {
    path: "/",
    name: "HomeView",
    // redirect: "/CreateProgram",
    component: HomeView,
    children: [
      {
        path: "/CreateProgram",
        name: "CreateProgram",
        component: () => import("@/views/CreateProgramView.vue"),
      },
      {
        path: "/transaction",
        name: "transaction",
        component: () => import("@/views/TransactionView.vue"),
      },
      {
        path: "/transactionDetail",
        name: "transactionDetail",
        component: () => import("../views/TransactionDetail.vue"),
      },
      {
        path: "/SearchView",
        name: "SearchView",
        component: () => import("@/views/SearchView.vue"),
      },
      {
        path: "/Others",
        name: "Others",
        component: () => import("@/views/Others.vue"),
      },
    ],
  },
  {
    path: "/Login",
    name: "Login",
    component: () => import("@/views/Login.vue"),
  },


  {
    path: "/:pathMatch(.*)*",
    name: "not-found",
    component: () => <h1>404 Not Found</h1>,
  },
];

const router = createRouter({
  history: createWebHashHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach(async (to, from) => {
  // const token = localStorage.getItem("token");
  // const isAdmin = !!token;
  const isAdmin = true;
  // const isAdmin = false;
  // let isAdmin;
  // if (token) {
  //   isAdmin = true;
  // } else {
  //   isAdmin = false;
  // }
  if (!isAdmin && to.name !== "Login") {
    console.log("啊? 你没有登录, 请先登录");

    return { name: "Login" };
  }
});

export default router;
