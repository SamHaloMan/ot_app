import { ref, onMounted } from 'vue'
import { defineStore } from 'pinia'

export const useSidebarStore = defineStore('sidebar', () => {
  const defaultVisible = false
  const defaultUnfoldable = false

  const visible = ref(
    localStorage.getItem('sidebar-visible') === null
      ? defaultVisible
      : JSON.parse(localStorage.getItem('sidebar-visible')),
  )
  const unfoldable = ref(
    localStorage.getItem('sidebar-unfoldable') === null
      ? defaultUnfoldable
      : JSON.parse(localStorage.getItem('sidebar-unfoldable')),
  )

  const toggleVisible = (value) => {
    visible.value = value !== undefined ? value : !visible.value
    localStorage.setItem('sidebar-visible', JSON.stringify(visible.value))
  }

  const toggleUnfoldable = () => {
    unfoldable.value = !unfoldable.value
    localStorage.setItem('sidebar-unfoldable', JSON.stringify(unfoldable.value))
  }

  onMounted(() => {
    if (localStorage.getItem('sidebar-visible') === null) {
      localStorage.setItem('sidebar-visible', JSON.stringify(defaultVisible))
    }
    if (localStorage.getItem('sidebar-unfoldable') === null) {
      localStorage.setItem('sidebar-unfoldable', JSON.stringify(defaultUnfoldable))
    }
  })

  return { visible, unfoldable, toggleVisible, toggleUnfoldable }
})
