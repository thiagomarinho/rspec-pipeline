# frozen_string_literal: true

pipeline 'pipeline.yml' do
  stage 'Build' do
    job 'SecurityScan' do
      it { is_expected.to run_when(push_to_master) }

      step 'Publish' do
        it { is_expected.to run_on_success_or_failure }
      end
    end
  end

  stage 'DeployToDev' do
    it { is_expected.to run_after('Build') }

    job 'Deploy' do
      step 'DoesSomethingOnNamespaceDev' do
        it { is_expected.to run_on_success }
      end
    end
  end

  stage 'DeployToCi' do
    it { is_expected.to run_after('DeployToDev') }
  end

  stage 'DeployToStage' do
    it { is_expected.to run_after('DeployToCi') }
  end

  stage 'DeployToProd' do
    it { is_expected.to run_after('DeployToStage') }
  end
end
