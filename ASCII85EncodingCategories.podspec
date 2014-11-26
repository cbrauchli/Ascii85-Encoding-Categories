Pod::Spec.new do |spec|
  spec.name         = 'ASCII85EncodingCategories'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/cbrauchli/Ascii85-Encoding-Categories'
  spec.authors      = { 'Chris Brauchli' => 'cbrauchli@gmail.com' }
  spec.summary      = 'Simple categories for NSData and NSString to support encoding them using RFC 1924 compliant ASCII85 encoding.'
  spec.source       = { :git => 'https://github.com/cbrauchli/Ascii85-Encoding-Categories.git', :tag => 'v0.0.1' }
  spec.source_files = '*.{h,m}'
  spec.requires_arc = true
end
