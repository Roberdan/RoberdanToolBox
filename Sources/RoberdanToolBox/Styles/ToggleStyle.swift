//
//  Styles.swift
//  MirrorableHR
//
//  Created by Roberto D’Angelo on 25/09/2020.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct CircleToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label.hidden()
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .imageScale(.large)
                .font(Font.title)
        }
    }
}

public struct HorizontalCheckmarkToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .red)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ? .green : .gray)
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}



public struct PowerToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .red)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            GeometryReader { geo in
                                Path { p in
                                    if !configuration.isOn {
                                        p.addRoundedRect(in: CGRect(x: 20, y: 10, width: 10.5, height: 10.5), cornerSize: CGSize(width: 7.5, height: 7.5), style: .circular, transform: .identity)
                                    } else {
                                        p.move(to: CGPoint(x: 51/2, y: 10))
                                        p.addLine(to: CGPoint(x: 51/2, y: 31-10))
                                    }
                                }.stroke(configuration.isOn ? Color.green : Color.gray, lineWidth: 2)
                            }
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}



public struct VerticalPowerToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .red)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            GeometryReader { geo in
                                Path { p in
                                    if !configuration.isOn {
                                        p.addRoundedRect(in: CGRect(x: 20, y: 10, width: 10.5, height: 10.5), cornerSize: CGSize(width: 7.5, height: 7.5), style: .circular, transform: .identity)
                                    } else {
                                        p.move(to: CGPoint(x: 51/2, y: 10))
                                        p.addLine(to: CGPoint(x: 51/2, y: 31-10))
                                    }
                                }.stroke(configuration.isOn ? Color.green : Color.gray, lineWidth: 2)
                            }
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

public struct ImageToggleStyle: ToggleStyle {
    
    var onImageName: String
    var offImageName: String
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(configuration.isOn ? onImageName : offImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

