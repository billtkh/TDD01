//
//  ListingCell.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import UIKit
import SnapKit

class ListingCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func updateUI(viewModel: ListingViewModel) {
        titleLabel.text = viewModel.listing.title
    }
}
