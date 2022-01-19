import UIKit

class NewsDetailTableViewCellViewModel {
    let id : Int
    let title : String
    let summary : String
    let imageURL : URL?
    var imageData: Data? = nil
    var newsSite: String?
    var publishedAt: String?
    var like : String
    
    init(
        id : Int,
        title : String,
        summary : String,
        imageURL : URL?,
        newsSite : String,
        publishedAt : String,
        like: String
    ){
        self.id = id
        self.title = title
        self.summary = summary
        self.imageURL = imageURL
        self.newsSite = newsSite
        self.publishedAt = publishedAt
        self.like = like
    }
}

class NewsDetailTableViewCell: UITableViewCell {
    
static let identifier = "NewsDetailTableViewCell"
    
     let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
         
        return label
    }()
     let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
     let newsImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
     let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .thin)
        return label
    }()
     let publishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .thin)
        return label
    }()
    let textField: UITextField = {
       let label = UITextField()
        var red = UIColor(red: 0.0/255.0, green: 64.0/255.0, blue: 221.0/255.0, alpha: 1)
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.placeholder = " Nome"
       return label
   }()
    let commentField: UITextView = {
       let label = UITextView()
        var red = UIColor(red: 0.0/255.0, green: 64.0/255.0, blue: 221.0/255.0, alpha: 1)
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
       return label
   }()
    let likeField: UITextView = {
       let label = UITextView()
        label.font = .systemFont(ofSize: 17, weight: .thin)
        
       return label
   }()
    let buttonField: UIButton = {
        let label = UIButton(type: .system)
        var red = UIColor(red: 0.0/255.0, green: 64.0/255.0, blue: 221.0/255.0, alpha: 1)
        var white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
        label.frame =  CGRect(x: 20, y: 20, width: 100, height: 50)
        label.setTitle("Comentar", for: .normal)
        label.setTitleColor(white, for: .normal)
        label.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        
        label.layer.borderColor = red.cgColor
        label.layer.backgroundColor = UIColor.systemBlue.cgColor
        label.addTarget(self, action: #selector(DetailsViewController.commented), for: .touchUpInside)
       return label
   }()
    let likeButton: UIButton = {
        let label = UIButton(type: .system)
        var red = UIColor(red: 0.0/255.0, green: 20.0/255.0, blue: 240.0/255.0, alpha: 1)
        var white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
        label.frame =  CGRect(x: 20, y: 20, width: 100, height: 50)
        label.setTitle("Like", for: .normal)
        label.setTitleColor(white, for: .normal)
        label.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = red.cgColor
        label.layer.backgroundColor = UIColor.systemBlue.cgColor
        label.addTarget(self, action: #selector(DetailsViewController.pressed), for: .touchUpInside)
       return label
   }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(publishedAtLabel)
        contentView.addSubview(textField)
        contentView.addSubview(buttonField)
        contentView.addSubview(commentField)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeField)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame=CGRect(
            x: 5,
            y: 20,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height + 70
        )
        
        subTitleLabel.frame = CGRect(
            x: 5,
            y: 20,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height+270
        )
        
        newsImageView.frame = CGRect(
            x: 5,
            y: 0,
            width: contentView.frame.size.width-10,
            height: contentView.frame.size.height/2
        )
        authorLabel.frame = CGRect(
            x: contentView.frame.size.width-140,
            y: 20,
            width: contentView.frame.size.width-70,
            height: contentView.frame.size.height+420
        )
        publishedAtLabel.frame = CGRect(
            x: 5,
            y: 20,
            width: contentView.frame.size.width-70,
            height: contentView.frame.size.height+420
        )
        buttonField.frame = CGRect(
            x: contentView.frame.size.width/2.8,
            y: 932,
            width: 100,
            height: 35
        )
        textField.frame = CGRect(
            x: 5,
            y: 760,
            width: contentView.frame.size.width-10,
            height: 60
        )
        commentField.frame = CGRect(
            x: 5,
            y: 827,
            width: contentView.frame.size.width-10,
            height: 100
        )
        likeField.frame = CGRect(
            x: contentView.frame.size.width/2,
            y: 970,
            width: 50,
            height: 55
        )
        likeButton.frame = CGRect(
            x: contentView.frame.size.width-65,
            y: 718,
            width: 50,
            height: 30
        )

        
    }
   
    override func prepareForReuse() {
         super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
        authorLabel.text = nil
        publishedAtLabel.text = nil
        likeField.text = nil
    }
    
    func configure(with viewModel : NewsDetailTableViewCellViewModel ){
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.summary
        authorLabel.text = viewModel.newsSite
        publishedAtLabel.text = viewModel.publishedAt
        likeField.text = viewModel.like
        
        //Image
        
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
            
        }
    }

}
