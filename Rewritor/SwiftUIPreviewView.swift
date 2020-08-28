//
//  SwiftUIPreviewView.swift
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

import SwiftUI

struct VCRepresentable<VCClass:UIViewController>: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		// leave this empty
	}
	
	@available(iOS 13.0.0, *)
	func makeUIViewController(context: Context) -> UIViewController {
		return VCClass()
	}
}

struct VCDocRepresentable: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		// leave this empty
	}
	
	@available(iOS 13.0.0, *)
	func makeUIViewController(context: Context) -> UIViewController {
		let navController = UINavigationController()
		let docVC = DocumentViewController();
		docVC.showPreviewData()
		navController.pushViewController(docVC, animated: false)
		return navController
	}
}

struct NavWrappedVCRepresentable<VCClass:UIViewController>: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		// leave this empty
	}
	
	@available(iOS 13.0.0, *)
	func makeUIViewController(context: Context) -> UIViewController {
		let navController = UINavigationController()
		navController.pushViewController(VCClass(), animated: false)
		return navController
	}
}

struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			/*VCDocRepresentable()
				.edgesIgnoringSafeArea(.all)
				.previewDevice(PreviewDevice(rawValue: "iPhone 8"))*/
		
			NavWrappedVCRepresentable<SettingsViewController>()
			.edgesIgnoringSafeArea(.all)
			.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
			.environment(\.colorScheme, .light)
			
			NavWrappedVCRepresentable<SettingsViewController>()
			.edgesIgnoringSafeArea(.all)
			.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
			.environment(\.colorScheme, .dark)
		}
	}
}
