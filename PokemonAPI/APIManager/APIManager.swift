//
//  APIManager.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 5/7/19.
//  Copyright © 2019 AEP. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod {get}
    var path: String {get}
    var encoding: ParameterEncoding {get}
    var parameters: Parameters? {get}
}

public struct ResponseError: Codable {
    public var code: Int
    public var message: String
    public var statusCode: Int?
    
    public init(code: Int, message: String, statusCode: Int?) {
        self.code = code
        self.message = message
        self.statusCode = statusCode
    }
}

public struct MultipartModel {
    public var fileExtension: String
    public var key: String
    public var fileName: String
    public var mimeType: String
    public var data: Data
    
    public init(key: String, fileName: String, mimeType: String, data: Data, fileExtension: String) {
        self.key = key
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
        self.fileExtension = fileExtension
    }
}

public class DCAPIManager {
    static public let shared = DCAPIManager()
    public var host = "" // host for endpoints server (eg. http://www.server.com/)
    public var apiVersion = "" // API version
    public let sessionManager = Alamofire.SessionManager.default
    public var enableDebug = false
    
    private init() {}
    
    public func request<T: Codable>(urlRequest: URLRequestConvertible, completion: @escaping (ResponseError?, T?) -> Void) {
        guard let urlRequest = urlRequest.urlRequest else { return }
        sessionManager.request(urlRequest)
            .validate()
            .responseData { [unowned self](response) in
                #if DEBUG
                if self.enableDebug {
                    if let request = response.request, let httpBody = request.httpBody {
                        print(String(data: httpBody, encoding: String.Encoding.utf8) as Any)
                    }
                    debugPrint(response)
                    if let data = response.result.value {
                        let returnData = String(data: data, encoding: .utf8)
                        print("response Data: \(String(describing: returnData))")
                    }
                }
                #endif
                var statusCode = 0
                if let statusCodeP = response.response?.statusCode {
                    statusCode = statusCodeP
                }
                switch response.result {
                case .success:
                    if let data = response.result.value {
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            completion(nil, decodedObject)
                        } catch {
                            #if DEBUG
                            if self.enableDebug {
                                print("JSON decode error: \(error)")
                            }
                            #endif
                            var error: ResponseError? = nil
                            if statusCode != 204 {
                                error = ResponseError(code: statusCode, message: "No se pudo decodificar el JSON.", statusCode: statusCode)
                            }
                            completion(error, nil)
                        }
                    } else {
                        // TODO: - The response return status: (200, 201, 204) and method has (PUT, POST, DELETE)
                        completion(nil, nil)
                    }
                case .failure(let error):
                    if let data = response.data {
                        do {
                            var error = try JSONDecoder().decode(ResponseError.self, from: data)
                            error.statusCode = statusCode
                            completion(error, nil)
                        } catch {
                            #if DEBUG
                            if self.enableDebug {
                                print("JSON decode error: \(error)")
                            }
                            #endif
                            let error = ResponseError(code: statusCode, message: "No se pudo decodificar JSON de error.", statusCode: statusCode)
                            completion(error, nil)
                        }
                    } else {
                        let urlError = error as! URLError
                        if !self.validateConnection(urlError) {
                            let error = ResponseError(code: urlError.errorCode, message: "No se pudo completar la petición, verifica tu conexión a internet y vuelve a intentar.", statusCode: statusCode)
                            completion(error, nil)
                        } else {
                            switch statusCode {
                            case 500...599: // Server error
                                let error = ResponseError(code: statusCode, message: "Por el momento no podemos completar la solicitud, intenta más tarde.", statusCode: statusCode)
                                completion(error, nil)
                            default:
                                let error = ResponseError(code: urlError.errorCode, message: "Ocurrió un error con la peticion.", statusCode: statusCode)
                                completion(error, nil)
                            }
                        }
                    }
                }
        }
    }
    
    public func upload<T: Codable>(urlRequest: URLRequestConvertible, parameters: Parameters?, multipartForms: [MultipartModel], completion: @escaping (ResponseError?, T?)->Void) {
        
        sessionManager.upload(multipartFormData: { (multipart) in
            
            if let params = parameters {
                for(key, value) in params {
                    let valueString = "\(value)"
                    guard let data = valueString.data(using: .utf8) else {continue}
                    multipart.append(data, withName: key)
                }
            }
            
            for model in multipartForms {
                multipart.append(model.data, withName: model.key, fileName: model.fileName + model.fileExtension, mimeType: model.mimeType)
            }
            
        }, with: urlRequest) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.validate().responseData { response in
                    
                    #if DEBUG
                    if self.enableDebug {
                        if let request = response.request, let httpBody = request.httpBody {
                            print(String(data: httpBody, encoding: String.Encoding.utf8) as Any)
                        }
                        debugPrint(response)
                        if let data = response.result.value {
                            let returnData = String(data: data, encoding: .utf8)
                            print("response Data: \(String(describing: returnData))")
                        }
                    }
                    #endif
                    var statusCode = 0
                    if let statusCodeP = response.response?.statusCode {
                        statusCode = statusCodeP
                    }
                    
                    
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                                completion(nil, decodedObject)
                            } catch {
                                #if DEBUG
                                if self.enableDebug {
                                    print("JSON decode error: \(error)")
                                }
                                #endif
                                
                                let _ = ResponseError(code: statusCode, message: "No se pudo decodificar el JSON.", statusCode: statusCode)
                                completion(nil, nil)
                            }
                        } else {
                            // TODO: - The response return status: (200, 201, 204) and method has (PUT, POST, DELETE)
                            completion(nil, nil)
                        }
                        
                    case .failure(let error):
                        if let data = response.data {
                            
                            do {
                                var error = try JSONDecoder().decode(ResponseError.self, from: data)
                                error.statusCode = statusCode
                                completion(error, nil)
                            } catch {
                                #if DEBUG
                                if self.enableDebug {
                                    print("JSON decode error: \(error)")
                                }
                                #endif
                                let error = ResponseError(code: statusCode, message: "No se pudo decodificar JSON de error.", statusCode: statusCode)
                                completion(error, nil)
                            }
                        } else {
                            let urlError = error as! URLError
                            if !self.validateConnection(urlError) {
                                let error = ResponseError(code: urlError.errorCode, message: "No se pudo completar la petición, verifica tu conexión a internet y vuelve a intentar.", statusCode: statusCode)
                                completion(error, nil)
                            } else {
                                switch statusCode {
                                case 500...599: // Server error
                                    let error = ResponseError(code: statusCode, message: "Por el momento no podemos completar la solicitud, intenta más tarde.", statusCode: statusCode)
                                    completion(error, nil)
                                default:
                                    let error = ResponseError(code: urlError.errorCode, message: "Ocurrió un error con la peticion.", statusCode: statusCode)
                                    completion(error, nil)
                                }
                            }
                        }
                    }
                    
                    
                }
                
            case .failure(let error):
                #if DEBUG
                print(error)
                #endif
                let error = ResponseError(code: 400, message: "Ocurrió un error al codificar los archivos", statusCode: 400)
                completion(error, nil)
            }
            
        }
        
    }
    
    public func upload(urlRequest: URLRequestConvertible, parameters: Parameters, fileData: Data?, fileName: String?, fileKey: String?, mimeType: String?, completion: @escaping (ResponseError?, Data?)->Void) {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            if let fileData = fileData, let fileName = fileName, let fileKey = fileKey, let mimeType = mimeType {
                multipartFormData.append(fileData, withName: fileKey, fileName: fileName, mimeType: mimeType)
            }
            for (key, value) in parameters {
                let valueString = value as! String
                multipartFormData.append(valueString.data(using: .utf8)!, withName: key)
            }
        }, with: urlRequest) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseData { response in
                    #if DEBUG
                    debugPrint(response)
                    #endif
                    guard let data = response.result.value else {
                        let error = ResponseError(code: (response.response?.statusCode)!, message: "Ocurrió un error", statusCode: (response.response?.statusCode)!)
                        completion(error, nil)
                        return
                    }
                    completion(nil, data)
                }
            case .failure(let encodingError):
                #if DEBUG
                print(encodingError)
                #endif
                let error = ResponseError(code: 400, message: "Ocurrió un error al codificar los archivos", statusCode: 400)
                completion(error, nil)
            }
        }
    }
    
    // MARK: - Private
    private func validateConnection(_ error: URLError) -> Bool {
        if error.code == .notConnectedToInternet ||
            error.code == .cannotConnectToHost ||
            error.code == .networkConnectionLost ||
            error.code == .timedOut {
            return false
        }
        return true
    }
}

