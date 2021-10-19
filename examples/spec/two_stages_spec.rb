require 'pipelinespec'

describe 'two-stages.yml' do
  context 'stage[Build]' do
    it 'should run security scan when changes are pushed to master' do
      expect(job('Build', 'SecurityScan')).to run_when(push_to_branch('master'))
      expect(step('Build', 'SecurityScan', 'Publish')).to run_on_success_or_failure
    end

    it 'should not run security scan when changes are pushed to a branch other than master' do
      expect(job('Build', 'SecurityScan')).not_to run_when(push_to_branch('not-master'))
    end
  end

  context 'stage[DeployToDv]' do
    it 'should run after Build' do
      expect(stage('DeployToDv')).to run_after('Build')
    end
  end

  context 'stage[DeployToCi]' do
    it 'should run after DeploytToDv' do
      expect(stage('DeployToCi')).to run_after('DeployToDv')
    end
  end
end
