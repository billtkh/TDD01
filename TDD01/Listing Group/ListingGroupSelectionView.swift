//
//  ListingGroupSelectionView.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class ListingGroupSelectionView: UIView {
    let viewModel: ListingGroupSelectionViewModel

    let disposeBag = DisposeBag()
    
    private(set) lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: viewModel.selections.map({ $0.title }))
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .lightGray
        segmentedControl.selectedSegmentTintColor = .darkText
        return segmentedControl
    }()
    
    public init(viewModel: ListingGroupSelectionViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupUI()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func binding() {
        segmentedControl.rx.selectedSegmentIndex
            .compactMap({ [weak self] index in
                let type = self?.viewModel.selections[index]
                print("[DEBUG] segmentedControl did select \(type?.title ?? "nil")")
                return type
            }).bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)
        
        viewModel.selectedType
            .asDriver()
            .compactMap { [weak self] type in
                return self?.viewModel.selections.firstIndex(of: type)
            }.drive(segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}
