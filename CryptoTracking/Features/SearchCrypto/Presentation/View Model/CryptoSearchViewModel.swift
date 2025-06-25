//
//  CryptoSearchViewModel.swift
//  CryptoTracking
//
//  Created by Mahmoud Farag on 21/12/2024.
//

import Foundation
import Combine
class CryptoSearchViewModel: BaseCryptoViewModel {
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private var allCryptos: [Cryptocurrency] = []
    
    override func fetchData() {
        super.fetchData()
        setupSearchListener()
    }
    
    override func handleSuccess(_ cryptos: Model) {
        DispatchQueue.main.async {
            super.handleSuccess(cryptos)
            self.allCryptos = cryptos
        }
    }
    
    private func setupSearchListener() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.state = .success(self.allCryptos)
                } else {
                    let filtered = self.allCryptos.filter {
                        $0.symbol.lowercased().contains(query.lowercased())
                    }
                    self.state = .success(filtered)
                }
            }
            .store(in: &cancellables)
    }
}
