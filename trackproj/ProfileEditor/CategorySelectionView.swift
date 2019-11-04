//
//  CategorySelectionView.swift
//  trackproj
//
//  Created by Danil on 21/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit




class CategorySelectionView: UIView {

	
	private weak var tableView: UITableView!
	
	var selectedRows: Set<IndexPath> = []

	weak var dataSource: CategorySelectionViewDataSource?
	weak var delegate: CategorySelectionViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let effectedView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		effectedView.frame = self.bounds
		self.addSubview(effectedView)
		
		let dismissButton = UIButton(frame: CGRect(x: bounds.midX - 15, y: 20, width: 30, height: 10))
		dismissButton.setImage( UIImage(named: "DownArrow.png"), for: .normal)
		dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
		
		let label = UILabel(frame: CGRect(x: bounds.midX - 50, y: 40, width: 100, height: 50))
		label.font = UIFont.systemFont(ofSize: 20)
		label.text = "Categories"
		
		self.addSubview(dismissButton)
		self.addSubview(label)
		
		let tableView = UITableView(frame: CGRect(x: 0, y: 90, width: self.bounds.width, height: self.bounds.height - 90), style: .plain)
		
		tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: .main), forCellReuseIdentifier: "categoryCell")
		
		self.tableView = tableView
		
		tableView.delegate = self
		tableView.isOpaque = true
		tableView.backgroundColor = .clear
		
		self.addSubview(tableView)
	}
	
	
	@objc func dismiss(_ button: UIButton){
		self.removeFromSuperview()
		delegate?.categorySelectionView(self, didFinishSelectingWithSelectedRows: selectedRows)
	
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	public func setDataSource(_ dataSource: CategorySelectionViewDataSource){
	
		tableView.dataSource = dataSource
		self.dataSource = dataSource
	}
	
	public func setDelegate(_ delegate: CategorySelectionViewDelegate){
		
		self.delegate = delegate
		
	}
	
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	
}


extension CategorySelectionView: UITableViewDelegate{
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cellToChange = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell{
			if selectedRows.contains(indexPath){
				selectedRows.remove(indexPath)
				cellToChange.tickImageView.isHidden = true
			}else{
				selectedRows.insert(indexPath)
				cellToChange.tickImageView.isHidden = false
			}
		}
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

}
	
protocol CategorySelectionViewDataSource: UITableViewDataSource {
	
}

protocol CategorySelectionViewDelegate: class{
	
	func categorySelectionView(_ view: CategorySelectionView, didFinishSelectingWithSelectedRows indexPaths: Set<IndexPath>)
}


