//
//  Library.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 23.06.2021.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action:
                                { print("123456") }, label: {
                                    Image(systemName: "play.fill")
                                        .frame(width: geometry.size.width / 2 - 10,
                                               height: 50)
                                        .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                        .background(Color.init(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)))
                                        .cornerRadius(10)
                                })
                        Button(action:
                                { print("54321") }, label: {
                                    Image(systemName: "arrow.2.circlepath")
                                        .frame(width: geometry.size.width / 2 - 10,
                                               height: 50)
                                        .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                        .background(Color.init(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)))
                                        .cornerRadius(10)
                                })
                    }
                }.padding().frame(height: 50).padding()
                Divider().padding(.leading).padding(.trailing)
                List {
                    LibraryCell()
                    Text("Second")
                    Text("Third")
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("trackImage").resizable().frame(width: 60, height: 60).cornerRadius(2)
            VStack {
                Text("Track name")
                Text("Artist name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
