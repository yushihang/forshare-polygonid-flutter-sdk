//
//  main.swift
//  myCC
//
//  Created by yushihang on 2023/11/15.
//


import Foundation


enum LogLevel: String {
    case info
    case warning
    case error
}

func log(_ level: LogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    let fileName = (file as NSString).lastPathComponent
    let logString = "\(Date()) [\(level.rawValue.uppercased())] [\(fileName):\(line) \(function)] \(message)"
    
    print(logString)
    
    appendLogToFile(logString)
}

func appendLogToFile(_ logString: String, fileURL: URL = URL(fileURLWithPath: "/Users/yushihang/Downloads/clang.log")) {
    do {
        try logString.appendLineToURL(fileURL: fileURL)
    } catch {
        print("Error writing to log file: \(error.localizedDescription)")
    }
}

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

let currentDirectory = FileManager.default.currentDirectoryPath

let arguments = CommandLine.arguments


var filteredArguments: [String] = []
var shouldSkipNextArgument = false

for (_, argument) in arguments.enumerated() {
    if shouldSkipNextArgument {
        shouldSkipNextArgument = false
        continue
    }
    
    if argument.hasPrefix("-arch") || argument.hasPrefix("-isysroot") {
        shouldSkipNextArgument = true
        continue
    }
    
    if argument.hasPrefix("-miphoneos-version-min") {
        filteredArguments.append("-mios-simulator-version-min=7.0")
        continue
    }
    
    
    filteredArguments.append(argument)
}
filteredArguments.remove(at: 0)

filteredArguments.insert("-isysroot", at: 0)
filteredArguments.insert("/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator17.0.sdk", at: 1)

filteredArguments.insert("-arch", at: 0)
filteredArguments.insert("arm64", at: 1)

filteredArguments.insert("-target", at: 0)
filteredArguments.insert("arm64-apple-ios14.0-simulator", at: 1)

log(.info, "Filtered arguments: \(filteredArguments)")


let process = Process()
process.launchPath = "/usr/bin/cc"

log(.info, "currentDirectory: \(currentDirectory)")
print(filteredArguments)
process.currentDirectoryPath = currentDirectory
process.arguments = filteredArguments


let outputPipe = Pipe()
let errorPipe = Pipe()
process.standardOutput = outputPipe
process.standardError = errorPipe


process.launch()
process.waitUntilExit()


let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
if let outputString = String(data: outputData, encoding: .utf8) {
    print("CC Output: \(outputString)")
}


let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
if let errorString = String(data: errorData, encoding: .utf8) {
    print("CC Error: \(errorString)")
}


let exitCode = process.terminationStatus
print("CC Exit Code: \(exitCode)")

Thread.sleep(forTimeInterval: 0.1)

