import UIKit

extension UIImageView {
    func setImageUrl(with imageUrl: String?) {
        guard let imageUrl = imageUrl,
              let urlPhoto = URL(string: imageUrl) else { return }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            do {
                let data = try Data(contentsOf: urlPhoto)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch _ {}
        }
    }
}
