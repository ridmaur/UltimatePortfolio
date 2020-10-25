//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Rob In der Maur on 25/10/2020.
//

import SwiftUI

struct ProjectsView: View {
    let showClosedProjects: Bool
    
    // not using the property wrapper
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects

        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(header: Text(project.title ?? "")) {
                        ForEach(project.items?.allObjects as? [Item] ?? []) { item in
                            Text(item.title ?? "")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

        static var previews: some View {
            ProjectsView(showClosedProjects: false)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
}
