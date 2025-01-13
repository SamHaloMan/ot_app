export function useOvertimeValidation(state) {
    const validateForm = () => {
        if (!state.selectedEmployees.value) return 'Please select an employee'
        if (!state.selectedProjects.value) return 'Please select a project'
        if (!state.selectedDate.value) return 'Please select a date'
        if (!state.timeStart.value || !state.timeEnd.value) return 'Please set overtime hours'

        if (state.hasBreak.value) {
            if (!state.timeBreakStart.value || !state.timeBreakEnd.value) {
                return 'Please set break hours'
            }

            const startMinutes = parseInt(state.timeStart.value.split(':')[0]) * 60 + parseInt(state.timeStart.value.split(':')[1])
            const endMinutes = parseInt(state.timeEnd.value.split(':')[0]) * 60 + parseInt(state.timeEnd.value.split(':')[1])
            const breakStartMinutes = parseInt(state.timeBreakStart.value.split(':')[0]) * 60 + parseInt(state.timeBreakStart.value.split(':')[1])
            const breakEndMinutes = parseInt(state.timeBreakEnd.value.split(':')[0]) * 60 + parseInt(state.timeBreakEnd.value.split(':')[1])

            if (breakStartMinutes < startMinutes || breakEndMinutes > endMinutes) {
                return 'Break time must be within overtime hours'
            }

            if (breakEndMinutes <= breakStartMinutes) {
                return 'Break end time must be after break start time'
            }
        }

        if (!state.overtimeReason.value) return 'Please provide overtime reason'
        return null
    }

    return { validateForm }
}