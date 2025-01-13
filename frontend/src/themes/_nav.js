export default [
  {
    component: 'CNavTitle',
    name: 'Home',
  },
  {
    component: 'CNavItem',
    name: 'Dashboard',
    to: '/dashboard',
    icon: 'cilHome',
    badge: {
      color: 'primary',
      text: 'HOME',
    },
  },
  {
    component: 'CNavTitle',
    name: 'Overtime',
  },
  {
    component: 'CNavItem',
    name: 'Overtime Request',
    to: '/overtime-form',
    icon: 'cilNotes',
  },
  {
    component: 'CNavTitle',
    name: 'Data',
  },
  {
    component: 'CNavItem',
    name: 'Overtime Analytics',
    to: '/data/overtime-analytics',
    icon: 'cilBarChart',
  },
  {
    component: 'CNavItem',
    name: 'History',
    to: '/data/overtime-history',
    icon: 'cilHistory',
  },
  {
    component: 'CNavItem',
    name: 'Employees',
    to: '/data/employees',
    icon: 'cilPeople',
  },
  {
    component: 'CNavItem',
    name: 'Projects',
    to: '/data/projects',
    icon: 'cilLaptop',
  },
]
