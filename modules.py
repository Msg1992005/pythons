import os
module = 'pandas numpy scikit-learn matplotlib math seaborn'
for i in module.split():
    try:
        os.system(f'pip install {i}')
    except:
        print('error in ', i)
