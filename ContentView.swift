import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \\Task.timestamp, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    @State private var newTaskTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New Task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTask) {
                        Image(systemName: "plus")
                    }
                    .disabled(newTaskTitle.isEmpty)
                }
                .padding()

                List {
                    ForEach(tasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    toggleTask(task)
                                }
                            Text(task.title ?? "")
                                .strikethrough(task.isCompleted)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .navigationTitle("TaskZen")
        }
    }

    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.timestamp = Date()
            newTask.title = newTaskTitle
            newTask.isCompleted = false

            do {
                try viewContext.save()
                newTaskTitle = ""
            } catch {
                print("Error saving task: \(error.localizedDescription)")
            }
        }
    }

    private func toggleTask(_ task: Task) {
        task.isCompleted.toggle()
        do {
            try viewContext.save()
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
}
